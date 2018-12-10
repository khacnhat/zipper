require_relative 'client_error'
require_relative 'externals'
require_relative 'zipper'
require 'json'
require 'rack'

class RackDispatcher

  def initialize
    @zipper = Zipper.new(self)
    @request_class = Rack::Request
  end

  def call(env)
    request = @request_class.new(env)
    path = request.path_info[1..-1] # lose leading /
    body = request.body.read
    name, args = validated_name_args(path, body)
    result = @zipper.public_send(name, *args)
    json_response(200, plain({ name => result }))
  rescue Exception => error
    diagnostic = pretty({
      'exception' => {
        'class' => error.class.name,
        'message' => error.message,
        'backtrace' => error.backtrace
      }
    })
    $stderr.puts(diagnostic)
    $stderr.flush
    json_response(status(error), diagnostic)
  end

  private # = = = = = = = = = = = = = = = = = = =

  def validated_name_args(name, body)
    @args = JSON.parse(body)
    args = case name
      when /^sha$/                  then []
      when /^zip_tag$/              then [kata_id, avatar_name, tag]
      when /^zip$/                  then [kata_id]
      else
        raise ClientError, 'json:malformed'
    end
    [name, args]
  end

  def json_response(status, body)
    [ status,
      { 'Content-Type' => 'application/json' },
      [ body ]
    ]
  end

  def plain(body)
    JSON.generate(body)
  end

  def pretty(body)
    JSON.pretty_generate(body)
  end

  def status(error)
    if error.is_a?(ClientError)
      400 # client_error
    else
      500 # server_error
    end
  end

  include Externals

  def self.request_args(*names)
    names.each { |name|
      define_method name, &lambda { @args[name.to_s] }
    }
  end

  request_args :kata_id, :avatar_name, :tag

end

require_relative 'client_error'
require_relative 'externals'
require_relative 'zipper'
require 'json'
require 'rack'

class RackDispatcher

  def call(env)
    zipper = Zipper.new(self)
    request = Rack::Request.new(env)
    name, args = validated_name_args(request)
    result = zipper.public_send(name, *args)
    json_response(200, { name => result })
  rescue => error
    info = {
      'exception' => {
        'class' => error.class.name,
        'message' => error.message,
        'backtrace' => error.backtrace
      }
    }
    $stderr.puts pretty(info)
    $stderr.flush
    json_response(status(error), info)
  end

  private # = = = = = = = = = = = = = = = = = = =

  def validated_name_args(request)
    name = request.path_info[1..-1] # lose leading /
    @args = JSON.parse(request.body.read)
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
    [ status, { 'Content-Type' => 'application/json' }, [ pretty(body) ] ]
  end

  def pretty(o)
    JSON.pretty_generate(o)
  end

  def status(error)
    error.is_a?(ClientError) ? 400 : 500
  end

  include Externals

  def self.request_args(*names)
    names.each { |name|
      define_method name, &lambda { @args[name.to_s] }
    }
  end

  request_args :kata_id, :avatar_name, :tag

end

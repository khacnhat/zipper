require_relative 'externals'
require_relative 'zipper'
require 'json'
require 'rack'

class RackDispatcher

  def call(env)
    zipper = Zipper.new(self)
    request = Rack::Request.new(env)
    name, args = validated_name_args(request)
    triple(200, { name => zipper.send(name, *args) })
  rescue => error
    info = {
      'exception' => {
        'class' => error.class.name,
        'message' => error.message,
        'backtrace' => error.backtrace
      }
    }
    $stderr.puts JSON.pretty_generate(info)
    $stderr.flush
    triple(400, info)
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
        raise ArgumentError.new('json:invalid')
    end
    [name, args]
  end

  def triple(n, body)
    [ n, { 'Content-Type' => 'application/json' }, [ body.to_json ] ]
  end

  include Externals

  def self.request_args(*names)
    names.each { |name|
      define_method name, &lambda { @args[name.to_s] }
    }
  end

  request_args :kata_id, :avatar_name, :tag

end

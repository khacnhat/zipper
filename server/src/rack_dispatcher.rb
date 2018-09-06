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

=begin
  def X_call(env)
    request = Rack::Request.new(env)
    @args = JSON.parse(request.body.read)
    case request.path_info
      when /sha/
        body = invoke('sha')
      when /zip_tag/
        body = invoke('zip_tag', kata_id, avatar_name, tag)
      when /zip/
        body = invoke('zip', kata_id)
    end
    [ 200, { 'Content-Type' => 'application/json' }, [ body.to_json ] ]
  end

  def X_invoke(name, *args)
    zipper = Zipper.new(self)
    { name => zipper.send(name, *args) }
    #triple(400, info)
    #rescue Exception => e
    #log << "EXCEPTION: #{e.class.name}.#{name} #{e.message}"
    #{ 'exception' => e.message }
  end
=end

end

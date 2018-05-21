require_relative 'externals'
require_relative 'zipper'
require 'json'
require 'rack'

class RackDispatcher

  def call(env)
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

  private

  def invoke(name, *args)
    zipper = Zipper.new(self)
    { name => zipper.send(name, *args) }
  rescue Exception => e
    log << "EXCEPTION: #{e.class.name}.#{name} #{e.message}"
    { 'exception' => e.message }
  end

  # - - - - - - - - - - - - - - - -

  include Externals

  def self.request_args(*names)
    names.each { |name|
      define_method name, &lambda { @args[name.to_s] }
    }
  end

  request_args :kata_id, :avatar_name, :tag

end

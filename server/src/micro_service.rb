require_relative 'externals'
require 'sinatra/base'
require 'json'

class MicroService < Sinatra::Base

  post '/zip' do
    poster(__method__, kata_id)
  end

  private

  include Externals

  def poster(name, *args)
    zipper_json('POST /', name, *args)
  end

  def zipper_json(prefix, caller, *args)
    name = caller.to_s[prefix.length .. -1]
    { name => zipper.send(name, *args) }.to_json
  rescue Exception => e
    log << "EXCEPTION: #{e.class.name} #{e.to_s}"
    { 'exception' => e.message }.to_json
  end

  # - - - - - - - - - - - - - - - -

  def self.request_args(*names)
    names.each { |name|
      define_method name, &lambda { args[name.to_s] }
    }
  end

  request_args :kata_id

  def args
    @args ||= JSON.parse(request_body_args)
  end

  def request_body_args
    request.body.rewind
    request.body.read
  end

end

require_relative 'externals'
require 'sinatra/base'
require 'json'

class MicroService < Sinatra::Base

  get '/zip' do
    getter(__method__, kata_id)
  end

  get '/zip_tag' do
    getter(__method__, kata_id, avatar_name, tag)
  end

  private

  include Externals

  def getter(caller, *args)
    name = caller.to_s['GET /'.length .. -1]
    { name => zipper.send(name, *args) }.to_json
  rescue Exception => e
    log << "EXCEPTION: #{e.class.name}.#{caller} #{e.message}"
    { 'exception' => e.message }.to_json
  end

  # - - - - - - - - - - - - - - - -

  def self.request_args(*names)
    names.each { |name|
      define_method name, &lambda { args[name.to_s] }
    }
  end

  request_args :kata_id, :avatar_name, :tag

  def args
    @args ||= JSON.parse(request_body_args)
  end

  def request_body_args
    request.body.rewind
    request.body.read
  end

end

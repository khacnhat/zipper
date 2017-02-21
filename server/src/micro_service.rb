require_relative 'externals'
require 'sinatra/base'
require 'json'

class MicroService < Sinatra::Base

  get '/zip_json' do
    zipper.zip_json(id)
  end

  get '/zip_git' do
    zipper.zip_git(id)
  end

  private

  include Externals

  def id
    args['id']
  end

  def args
    @args ||= JSON.parse(request_body_args)
  end

  def request_body_args
    request.body.rewind
    request.body.read
  end

end

require_relative 'zipper_service'
require 'sinatra'
require 'sinatra/base'

class Demo < Sinatra::Base

  get '/zip' do
    tgz_filename = zipper.zip('7AF23949B7')

    colour = 'white'
    border = 'border:1px solid black'
    padding = 'padding:10px'
    background = "background:#{colour}"
    "<pre style='#{border};#{padding};#{background}'>" +
    tgz_filename +
    '</pre>'
  end

  private

  def zipper
    ZipperService.new
  end

end



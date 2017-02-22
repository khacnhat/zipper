require 'sinatra/base'

require_relative 'zipper_service'

class Demo < Sinatra::Base

  get '/' do
  end

  private

  def zipper
    ZipperService.new
  end

end



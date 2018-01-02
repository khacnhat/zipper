require_relative 'http_service'

class ZipperService

  def zip(kata_id)
    get(__method__, kata_id)
  end

  def zip_tag(kata_id, avatar_name, tag)
    get(__method__, kata_id, avatar_name, tag)
  end

  private

  include HttpService

  def hostname
    'zipper'
  end

  def port
    ENV['CYBER_DOJO_ZIPPER_SERVER_PORT']
  end

end

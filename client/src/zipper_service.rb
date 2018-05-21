require_relative 'http_service'

class ZipperService

  def sha
    get(__method__)
  end

  def zip(kata_id)
    get(__method__, kata_id)
  end

  def zip_tag(kata_id, avatar_name, tag)
    get(__method__, kata_id, avatar_name, tag)
  end

  private

  include HttpService

  def hostname
    ENV['CYBER_DOJO_ZIPPER_SERVICE_NAME']
  end

  def port
    ENV['CYBER_DOJO_ZIPPER_SERVICE_PORT']
  end

end

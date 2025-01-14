require_relative 'http_json_service'

class StorerService

  def initialize(_parent)
    @hostname = ENV['STORER_HOSTNAME'] || 'storer'
    @port = 4577
  end

  def kata_manifest(kata_id)
    get(__method__, kata_id)
  end

  def avatars_started(kata_id)
    get(__method__, kata_id)
  end

  def avatar_increments(kata_id, avatar_name)
    get(__method__, kata_id, avatar_name)
  end

  def tag_visible_files(kata_id, avatar_name, tag)
    get(__method__, kata_id, avatar_name, tag)
  end

  private

  include HttpJsonService

  attr_reader :hostname, :port

end

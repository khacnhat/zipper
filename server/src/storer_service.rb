require_relative 'http_service'
require 'json'
require 'net/http'

class StorerService

  def initialize(_parent)
  end

  def kata_manifest(kata_id)
    get(__method__, kata_id)
  end

  def started_avatars(kata_id)
    get(__method__, kata_id)
  end

  def avatar_increments(kata_id, avatar_name)
    get(__method__, kata_id, avatar_name)
  end

  def tags_visible_files(kata_id, avatar_name, was_tag, now_tag)
    get(__method__, kata_id, avatar_name, was_tag, now_tag)
  end

  private

  include HttpService
  def hostname; 'storer'; end
  def port; 4577; end

end

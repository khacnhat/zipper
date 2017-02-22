require_relative 'id_splitter'
require_relative 'nearest_ancestors'

class Zipper

  def initialize(parent)
    @parent = parent
  end

  attr_reader :parent

  def zip_json(kata_id)
    # Create files off /tmp in new non-git format
    zip_path = '/tmp/cyber-dojo/zips'
    kata_path = "#{zip_path}/#{outer(kata_id)}/#{inner(kata_id)}"
    kata_dir = disk[kata_path]
    kata_dir.make
    kata_dir.write_json('manifest.json', storer.kata_manifest(kata_id))
    storer.started_avatars(kata_id).each do |avatar_name|
      avatar_path = "#{kata_path}/#{avatar_name}"
      avatar_dir = disk[avatar_path]
      avatar_dir.make
      rags = storer.avatar_increments(kata_id, avatar_name)
      rags.shift # tag0
      avatar_dir.write_json('increments.json', rags)
      (1..rags.size).each do |tag|
        tag_path = "#{avatar_path}/#{tag}"
        tag_dir = disk[tag_path]
        tag_dir.make
        visible_files = storer.tag_visible_files(kata_id, avatar_name, tag)
        tag_dir.write_json('manifest.json', visible_files)
      end
    end
    # and tar that
    cd_cmd = "cd #{zip_path}"
    tgz_filename = "#{zip_path}/#{kata_id}.tgz"
    tar_cmd = "tar -zcf #{tgz_filename} #{outer(kata_id)}/#{inner(kata_id)}"
    shell.exec(cd_cmd, tar_cmd)
    tgz_filename
  end

  # - - - - - - - - - - - - - - - - - - - - -

  def zip_git(kata_id)
    # Create files off /tmp in git format
    zip_path = '/tmp/cyber-dojo/zips'
    kata_path = "#{zip_path}/#{outer(kata_id)}/#{inner(kata_id)}"
    kata_dir = disk[kata_path]
    kata_dir.make
    kata_dir.write_json('manifest.json', storer.kata_manifest(kata_id))

    # create git repo
    # TODO...

    cd_cmd = "cd #{zip_path}"
    tgz_filename = "#{zip_path}/#{kata_id}.tgz"
    tar_cmd = "tar -zcf #{tgz_filename} #{outer(kata_id)}/#{inner(kata_id)}"
    shell.exec(cd_cmd, tar_cmd)
    tgz_filename
  end

  private

  include IdSplitter

  include NearestAncestors
  def storer; nearest_ancestors(:storer); end
  def  shell; nearest_ancestors(:shell ); end
  def   disk; nearest_ancestors(:disk  ); end
  def    git; nearest_ancestors(:git   ); end

end

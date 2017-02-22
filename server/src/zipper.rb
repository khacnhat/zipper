require_relative 'id_splitter'
require_relative 'nearest_ancestors'

class Zipper

  def initialize(parent)
    @parent = parent
  end

  attr_reader :parent

  def zip_json(kata_id)
    # Create tgz file in storer's json format
    kata_path = "#{zip_path}/#{outer(kata_id)}/#{inner(kata_id)}"
    kata_dir = disk[kata_path]
    kata_dir.make
    kata_dir.write_json('manifest.json', storer.kata_manifest(kata_id))
    storer.started_avatars(kata_id).each do |avatar_name|
      avatar_path = "#{kata_path}/#{avatar_name}"
      avatar_dir = disk[avatar_path]
      avatar_dir.make

      rags = storer.avatar_increments(kata_id, avatar_name)
      # storer does not store tag0 is each avatar's manifest.
      # Retain this form so a tgz file can be copied between
      # storers on different servers.
      rags.shift

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
    # Create tgz file in git format
    kata_path = "#{zip_path}/#{outer(kata_id)}/#{inner(kata_id)}"
    kata_dir = disk[kata_path]
    kata_dir.make
    kata_dir.write_json('manifest.json', storer.kata_manifest(kata_id))

=begin
    storer.started_avatars(kata_id).each do |avatar_name|
      avatar_path = "#{kata_path}/#{avatar_name}"
      avatar_dir = disk[avatar_path]
      avatar_dir.make
      git.setup(avatar_path, avatar_name, "#{avatar_name}@cyber-dojo.org")
      sandbox_path = "#{avatar_path}/sandbox"
      sandbox_dir = disk[sandbox_path]
      sandbox_dir.make
      rags = storer.avatar_increments(kata_id, avatar_name)
      (0..rags.size).each do |tag|
        # TODO: ensure git repos are in exact form I used to use
        # that way they too can be copied from one storer to another.
        avatar_dir.write_json('increments.json', rags[1..tag])
        git.add(avatar_path, 'increments.json')
        visible_files = storer.tag_visible_files(kata_id, avatar_name, tag)
        visible_files.each do |filename, content|
          sandbox_dir.write(filename, content)
          git.add(sandbox_path, filename)
        end
        git.commit(avatar_path, tag)
        visible_files.keys.each do |filename|
          git.rm(sandbox_path, filename)
        end
        git.rm(avatar_path, 'increments.json')
      end
    end
=end

    cd_cmd = "cd #{zip_path}"
    tgz_filename = "#{zip_path}/#{kata_id}.tgz"
    tar_cmd = "tar -zcf #{tgz_filename} #{outer(kata_id)}/#{inner(kata_id)}"
    shell.exec(cd_cmd, tar_cmd)
    tgz_filename
  end

  private

  def zip_path
    ENV['CYBER_DOJO_ZIPPER_ROOT']
  end

  include IdSplitter

  include NearestAncestors
  def storer; nearest_ancestors(:storer); end
  def  shell; nearest_ancestors(:shell ); end
  def   disk; nearest_ancestors(:disk  ); end
  def    git; nearest_ancestors(:git   ); end

end

require_relative 'id_splitter'
require_relative 'nearest_ancestors'

class Zipper

  def initialize(parent)
    @parent = parent
  end

  attr_reader :parent

  def zip(kata_id)
    manifest = storer.kata_manifest(kata_id)
    # Creates tgz file in storer's json format
    kata_path = "#{zip_path}/#{outer(kata_id)}/#{inner(kata_id)}"
    shell.exec("rm -rf #{kata_path}")
    kata_dir = disk[kata_path]
    kata_dir.make
    kata_dir.write_json('manifest.json', manifest)
    storer.started_avatars(kata_id).each do |avatar_name|
      avatar_path = "#{kata_path}/#{avatar_name}"
      avatar_dir = disk[avatar_path]
      avatar_dir.make

      rags = storer.avatar_increments(kata_id, avatar_name)
      # storer does not store tag0 in each avatar's manifest.
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
    tgz_filename = "#{zip_path}/#{kata_id}.tgz"
    tar_cmd = "tar -zcf #{tgz_filename} #{outer(kata_id)}/#{inner(kata_id)}"
    shell.cd_exec(zip_path, tar_cmd)
    tgz_filename
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - -

  def zip_tag(kata_id, avatar_name, tag)
    visible_files = storer.tag_visible_files(kata_id, avatar_name, tag)
    tag_path = "#{zip_path}/#{kata_id}/#{avatar_name}/#{tag}"
    shell.exec("rm -rf #{tag_path}")
    tag_dir = disk[tag_path]
    tag_dir.make

    # Assumes kata is from after start-point re-architecture
    kata_manifest = storer.kata_manifest(kata_id)
    start_point_manifest = {}
    start_point_manifest['visible_filenames'] = visible_files.keys.sort
    required = [ 'display_name', 'image_name', 'red_amber_green' ]
    required.each do |key|
      start_point_manifest[key] = kata_manifest[key]
    end
    optional = [ 'filename_extension', 'tab_size', 'progress_regexs' ]
    optional.each do |key|
      start_point_manifest[key] = kata_manifest[key]
    end
    # strip out optional entries that weren't there
    start_point_manifest.delete_if { |_,value| value.nil? }
    tag_dir.write_json('manifest.json', start_point_manifest)

    visible_files.each do |filename, content|
      tag_dir.write(filename, content)
    end
    tgz_filename = "#{zip_path}/#{kata_id}_#{avatar_name}_#{tag}.tgz"
    tar_cmd = "tar -zcf #{tgz_filename} #{kata_id}/#{avatar_name}/#{tag}"
    shell.cd_exec(zip_path, tar_cmd)
    tgz_filename
  end

  private

  include IdSplitter

  def zip_path
    ENV['CYBER_DOJO_ZIPPER_ROOT']
  end

  include NearestAncestors
  def storer; nearest_ancestors(:storer); end
  def  shell; nearest_ancestors(:shell ); end
  def   disk; nearest_ancestors(:disk  ); end

end

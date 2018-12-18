require_relative 'id_splitter'
require 'base64'

class Zipper

  def initialize(externals)
    @externals = externals
  end

  def sha
    ENV['SHA']
  end

  def zip(kata_id)
    manifest = storer.kata_manifest(kata_id)
    # Creates tgz file in storer's json format
    Dir.mktmpdir("zipper") do |tmp_zip_path|
      kata_path = "#{tmp_zip_path}/#{outer(kata_id)}/#{inner(kata_id)}"
      kata_dir = disk[kata_path]
      kata_dir.make
      kata_dir.write_json('manifest.json', manifest)
      storer.avatars_started(kata_id).each do |avatar_name|
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
      tgz_filename = "#{tmp_zip_path}/#{kata_id}.tgz"
      tar_cmd = "tar -zcf #{tgz_filename} #{outer(kata_id)}/#{inner(kata_id)}"
      shell.cd_exec(tmp_zip_path, tar_cmd)
      File.open(tgz_filename, 'rb') { |file | Base64.encode64(file.read) }
    end
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - -

  def zip_tag(kata_id, avatar_name, tag)
    visible_files = storer.tag_visible_files(kata_id, avatar_name, tag)
    visible_files.delete('output')
    manifest = storer.kata_manifest(kata_id)
    manifest['visible_filenames'] = visible_files.keys.sort
    %w( visible_files id exercise created ).each do |key|
      manifest.delete(key)
    end

    # Assumes kata is from after start-point re-architecture
    Dir.mktmpdir("zipper") do |tmp_zip_path|
      # save the manifest
      tag_path = "#{tmp_zip_path}/#{kata_id}/#{avatar_name}/#{tag}"
      tag_dir = disk[tag_path]
      tag_dir.make
      tag_dir.write('manifest.json', JSON.pretty_unparse(manifest))
      # save the visible files
      visible_files.each do |pathed_filename, content|
        src_dir = disk[tag_path + '/' + File.dirname(pathed_filename)]
        src_dir.make
        src_dir.write(File.basename(pathed_filename), content)
      end
      # tar up the dir holding the manifest and visible files
      tgz_filename = "#{tmp_zip_path}/#{kata_id}_#{avatar_name}_#{tag}.tgz"
      tar_cmd = "tar -zcf #{tgz_filename} #{kata_id}/#{avatar_name}/#{tag}"
      shell.cd_exec(tmp_zip_path, tar_cmd)
      File.open(tgz_filename, 'rb') { |file| Base64.encode64(file.read) }
    end
  end

  private # = = = = = = = = = = = = = = = = = =

  include IdSplitter

  def storer
    @externals.storer
  end

  def shell
    @externals.shell
  end

  def disk
    @externals.disk
  end

end

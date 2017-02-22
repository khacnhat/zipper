require_relative 'zipper_test_base'
require_relative 'null_logger'
require_relative '../../src/id_splitter'

class ZipperTest < ZipperTestBase

  def self.hex_prefix; '03D'; end

  def log
    @log ||= NullLogger.new(self)
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'BEC',
  'zip_json with empty id raises' do
    error = assert_raises(StandardError) { zip_json(id = '') }
    assert_equal 'StorerService:kata_manifest:Storer:invalid kata_id', error.message
  end

  test 'BED',
  'zip_git with empty id raises' do
    error = assert_raises(StandardError) { zip_git(id = '') }
    assert_equal 'StorerService:kata_manifest:Storer:invalid kata_id', error.message
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test '849',
  'zip_json with bad id raises' do
    error = assert_raises(StandardError) { zip_json(id = 'XX') }
    assert_equal 'StorerService:kata_manifest:Storer:invalid kata_id', error.message
  end

  test '850',
  'zip_git with bad id raises' do
    error = assert_raises(StandardError) { zip_git(id = 'XX') }
    assert_equal 'StorerService:kata_manifest:Storer:invalid kata_id', error.message
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test '561',
  'zip_json format is ready for saving directly into storer' do
    ids.each do |id|
      tgz_filename = zip_json(id)
      assert_json_zipped(id, tgz_filename)
    end
  end

  test '562',
  'zip_git format is useful for creating new start-points' do
    ids.each do |id|
      tgz_filename = zip_git(id)
      assert_git_zipped(id, tgz_filename)
    end
  end

  private

  def assert_json_zipped(id, tgz_filename)
    assert File.exists?(tgz_filename), "File.exists?(#{tgz_filename})"
    Dir.mktmpdir('zipper') do |tmp_dir|
      _,status = shell.cd_exec(tmp_dir, "cat #{tgz_filename} | tar xfz -")
      assert_equal 0, status

      kata_path = "#{tmp_dir}/#{outer(id)}/#{inner(id)}"
      zipper_manifest = disk[kata_path].read_json('manifest.json')
      storer_manifest = storer.kata_manifest(id)
      assert_equal storer_manifest, zipper_manifest, 'manifests are the same'

      storer.started_avatars(id).each do |avatar_name|
        avatar_path = "#{kata_path}/#{avatar_name}"
        zipper_rags = disk[avatar_path].read_json('increments.json')
        storer_rags = storer.avatar_increments(id, avatar_name)
        # storer does not store tag0 is each avatar's manifest.
        # Retain this form so a tgz file can be copied between
        # storers on different servers.
        storer_rags.shift
        assert_equal storer_rags, zipper_rags, 'increments are the same'

        (1..zipper_rags.size).each do |tag|
          tag_path = "#{avatar_path}/#{tag}"
          zipper_tag = disk[tag_path].read_json('manifest.json')
          storer_tag = storer.tag_visible_files(id, avatar_name, tag)
          assert_equal storer_tag, zipper_tag, "tag is are the same"
        end
      end
    end
  end

  def assert_git_zipped(id, tgz_filename)
    assert File.exists?(tgz_filename), "File.exists?(#{tgz_filename})"
    Dir.mktmpdir('zipper') do |tmp_dir|
      _,status = shell.cd_exec(tmp_dir, "cat #{tgz_filename} | tar xfz -")
      assert_equal 0, status

      kata_path = "#{tmp_dir}/#{outer(id)}/#{inner(id)}"
      zipper_manifest = disk[kata_path].read_json('manifest.json')
      storer_manifest = storer.kata_manifest(id)
      assert_equal storer_manifest, zipper_manifest, 'manifests are the same'

=begin
      # TODO...
=end
    end
  end

  include IdSplitter

  def ids
    [
      'DADD67B4EF', # empty kata
      'F6986222F0', # one avatar and no traffic-lights
      '1D1B0BE42D', # one avatar and one traffic-lights
      '697C14EDF4', # one avatar and three traffic-lights
      '7AF23949B7', # three avatar each with three traffic-lights
    ]
  end

end

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
  'zip with empty id raises' do
    error = assert_raises(StandardError) { zip_json(id = '') }
    assert_equal 'StorerService:kata_manifest:Storer:invalid kata_id', error.message
    error = assert_raises(StandardError) { zip_git(id = '') }
    assert_equal 'StorerService:kata_manifest:Storer:invalid kata_id', error.message
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test '849',
  'zip with bad id raises' do
    error = assert_raises(StandardError) { zip_json(id = 'XX') }
    assert_equal 'StorerService:kata_manifest:Storer:invalid kata_id', error.message
    error = assert_raises(StandardError) { zip_git(id = 'XX') }
    assert_equal 'StorerService:kata_manifest:Storer:invalid kata_id', error.message
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test '561',
  'zip into json format ready for saving directly into storer' do
    ids.each do |id|
      tgz_filename = zip_json(id)
      assert_json_zipped(id, tgz_filename)
    end
  end
  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


  test 'A66',
  'zip into git format useful for creating new start-points' do
    ids.each do |id|
      tgz_filename = zip_git(id)
      assert_git_zipped(id, tgz_filename)
    end
  end

  private

  def assert_json_zipped(id, tgz_filename)
    assert File.exists?(tgz_filename), "File.exists?(#{tgz_filename})"
    #untar it into execute-around tmp dir
    #then compare untarred content with masters retrieved from from storer

    #manifest = storer.kata_manifest(id)
    #compare with untarred manifest.json

    #avatars = storer.started_avatars(id)
    #compare with untarred avatar-dirs

    #rags = storer.avatar_increments(id, 'lion')
    #compare with untarred versions

    #compare visible-files with those from storer
    #files = storer.tag_visible_files(id, 'lion', 1)
  end

  def assert_git_zipped(id, tgz_filename)
    assert File.exists?(tgz_filename), "File.exists?(#{tgz_filename})"
    #...
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

=begin
    # unzip new tarfile
    tarfile_name = @tar_dir + '/' + "#{@id}.tgz"
    assert File.exists?(tarfile_name), "File.exists?(#{tarfile_name})"
    untar_path = @tar_dir + '/' + 'untar'
    `rm -rf #{untar_path}`
    `mkdir -p #{untar_path}`
    `cd #{untar_path} && cat #{tarfile_name} | tar xfz -`

    # new format dir exists for kata
    kata_path = "#{untar_path}/#{outer(@id)}/#{inner(@id)}"
    kata_dir = disk[kata_path]
    assert kata_dir.exists?, '1.kata_dir.exists?'
    assert kata_dir.exists?('manifest.json'), "2.kata_dir.exists?('manifest.json')"
    manifest = kata_dir.read_json('manifest.json')
    assert_equal storer.kata_manifest(@id), manifest, '3.manifests are the same'

    # new format dir exists for each avatar
    katas[@id].avatars.each do |avatar|
      avatar_path = "#{kata_path}/#{avatar.name}"
      avatar_dir = disk[avatar_path]
      assert avatar_dir.exists?, '4.avatar_dir.exists?'
      assert avatar_dir.exists?('increments.json'), "5.avatar_dir.exists?('increments.json')"
      rags = avatar_dir.read_json('increments.json')
      # new format dir exists for each tag
      (1..rags.size).each do |tag|
        tag_path = "#{avatar_path}/#{tag}"
        tag_dir = disk[tag_path]
        assert tag_dir.exists?, '6. tag_dir.exists?'
        assert tag_dir.exists?('manifest.json'), "7.tag_dir.exists?('manifest.json')"
        expected = storer.tag_visible_files(@id, avatar.name, tag)
        actual = tag_dir.read_json('manifest.json')
        assert_equal expected, actual, '8.manifests are the same'
      end
    end
  end
=end


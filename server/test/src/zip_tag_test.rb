require_relative 'zipper_test_base'
require_relative '../../src/id_splitter'

class ZipTagTest < ZipperTestBase

  def self.hex_prefix; '0AA'; end

  def log
    @log ||= NullLogger.new(self)
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  # Positive tests
  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test '2A8',
  'zip_tag unzipped content match masters in storer',
  'on started avatar with no tests tag-0 successful' do
    started_kata_args.each do |kata_id, avatar_name, max_tag|
      (0..max_tag).each do |tag|
        tgz_filename = zip_tag(kata_id, avatar_name, tag)
        assert File.exists? tgz_filename
        Dir.mktmpdir('zipper') do |tmp_dir|
          _,status = shell.cd_exec(tmp_dir, "cat #{tgz_filename} | tar xfz -")
          assert_equal 0, status
          tgz_dir = disk[[tmp_dir, kata_id, avatar_name, tag].join('/')]
          visible_files = storer.tag_visible_files(kata_id, avatar_name, tag)
          visible_files.delete('output')
          visible_files.each do |filename,expected|
            actual = tgz_dir.read(filename)
            assert_equal expected, actual, filename
          end

          start_point_manifest = tgz_dir.read_json('manifest.json')
          assert_equal visible_files.keys.sort, start_point_manifest['visible_filenames']

          kata_manifest = storer.kata_manifest(kata_id)
          required = [ 'display_name', 'image_name', 'red_amber_green' ]
          required.each do |key|
            refute_nil start_point_manifest[key]
            assert_equal kata_manifest[key], start_point_manifest[key]
          end
          optional = [ 'filename_extension', 'tab_size' ]
          optional.each do |key|
            assert_equal kata_manifest[key], start_point_manifest[key]
          end
          patched = 'progress_regexs'
          unless kata_manifest[patched] == []
            assert_equal kata_manifest[patched], start_point_manifest[patched]
          end
        end
      end
    end
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  # Negative tests
  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test '885',
  'zip_tag with invalid argument raises' do
    ukid = unstarted_kata_id
    skid = started_kata_args[0][kata_id=0]
    skan = started_kata_args[0][avatar_name=1]
    args = [
      ['',   'salmon', 0,      'kata_id'    ],
      ['XX', 'salmon', 0,      'kata_id'    ],
      [ukid, '',       0,      'avatar_name'],
      [ukid, 'xxx',    0,      'avatar_name'],
      [ukid, 'salmon', 0,      'avatar_name'],
      [skid, skan,    '',      'tag'        ],
      [skid, skan,  'xx',      'tag'        ],
      [skid, skan,    -1,      'tag'        ],
      [skid, skan,     1,      'tag'        ],
    ]
    args.each do |kata_id, avatar_name, tag, arg_name|
      error = assert_raises(StandardError) {
        zip_tag(kata_id, avatar_name, tag)
      }
      assert error.message.end_with?("invalid #{arg_name}"), error.message
    end
  end

end

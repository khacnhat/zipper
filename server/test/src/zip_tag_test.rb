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
    args = [
      ['F6986222F0', 'spider', 0],
      ['1D1B0BE42D', 'hippo',  0],
      ['1D1B0BE42D', 'hippo',  1],
      ['697C14EDF4', 'turtle', 0],
      ['697C14EDF4', 'turtle', 1],
      ['697C14EDF4', 'turtle', 2],
      ['697C14EDF4', 'turtle', 3],
      ['7AF23949B7', 'alligator', 3],
      ['7AF23949B7', 'heron',     3],
      ['7AF23949B7', 'squid',     3],
    ]
    args.each do |kata_id, avatar_name, tag|
      tgz_filename = zip_tag(kata_id, avatar_name, tag)
      assert File.exists? tgz_filename
      Dir.mktmpdir('zipper') do |tmp_dir|
        _,status = shell.cd_exec(tmp_dir, "cat #{tgz_filename} | tar xfz -")
        assert_equal 0, status
        tgz_dir = disk[[tmp_dir, kata_id, avatar_name, tag].join('/')]
        masters = storer.tag_visible_files(kata_id, avatar_name, tag)
        masters.each do |filename,expected|
          actual = tgz_dir.read(filename)
          assert_equal expected, actual, filename
        end
      end
    end
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  # Negative tests
  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test '885',
  'zip_tag with invalid argument raises' do
    args = [
      ['',           'salmon', 0,    'kata_id'    ],
      ['XX',         'salmon', 0,    'kata_id'    ],
      ['DADD67B4EF', '',       0,    'avatar_name'],
      ['DADD67B4EF', 'xxx',    0,    'avatar_name'],
      ['DADD67B4EF', 'salmon', 0,    'avatar_name'],
      ['F6986222F0', 'spider', '',   'tag'        ],
      ['F6986222F0', 'spider', 'xx', 'tag'        ],
      ['F6986222F0', 'spider', -1,   'tag'        ],
      ['F6986222F0', 'spider', 1,    'tag'        ]

    ]
    args.each do |kata_id, avatar_name, tag, arg_name|
      error = assert_raises(StandardError) {
        zip_tag(kata_id, avatar_name, tag)
      }
      assert error.message.end_with?("invalid #{arg_name}"), error.message
    end
  end

end

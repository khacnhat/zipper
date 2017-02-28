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
  'zip_tag on started avatar with no tests tag-0 successful' do
    tgz_filename = zip_tag('F6986222F0', 'spider', 0)
    assert File.exists? tgz_filename
    Dir.mktmpdir('zipper') do |tmp_dir|
      _,status = shell.cd_exec(tmp_dir, "cat #{tgz_filename} | tar xfz -")
      assert_equal 0, status
      # TODO: check file contents
    end
  end

  #TODO: avatar-started hit-test tag 1

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
    args.each do |kata_id, avatar_name, tag, expected|
      error = assert_raises(StandardError) {
        zip_tag(kata_id, avatar_name, tag)
      }
      assert_raises_invalid(error, expected)
    end
  end

  private

  def assert_raises_invalid(error, message)
    assert error.message.end_with?("invalid #{message}"), error.message
  end

end

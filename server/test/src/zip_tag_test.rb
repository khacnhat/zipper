require_relative 'zipper_test_base'
require_relative '../../src/id_splitter'

class ZipTagTest < ZipperTestBase

  def self.hex_prefix; '0AA'; end

  test '885',
  'zip_tag with empty id raises' do
    error = assert_raises(StandardError) {
      zip_tag(id = '', 'salmon', 1)
    }
    assert error.message.end_with? 'invalid kata_id'
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  #bad id raises
  #empty avatar_name raises
  #bad avatar_name raises
  #empty tag raises
  #bad tag raises
  #tag less than zero raises
  #tag greater than number of traffic-lights raises

  #avatar-not-started raises
  #avatar-started but not hit test yet tag 0
  #avatar-started hit-test tag 1

=begin
  test '2A8',
  'zip_tag on tag-0 successful' do
    tgz_filename = zip_tag(ids[1], 'spider', 0)
    assert File.exists? tgz_filename
  end
=end

end

require_relative 'test_base'

class ZipTest < TestBase

  def self.hex_prefix; 'CE167'; end

  test '8BE',
  'zip empty kata_id raises' do
    error = assert_raises(StandardError) {
      zip(kata_id = ' ')
    }
    assert_equal expected_error_message, error.message
  end

  # - - - - - - - - - - - - - - - - - - - - - - - -

  test '8BF',
  'zip bad kata_id raises' do
    error = assert_raises(StandardError) {
      zip(kata_id = 'XX')
    }
    assert_equal expected_error_message, error.message
  end

  # - - - - - - - - - - - - - - - - - - - - - - - -

  test '6F8',
  'unzipped tgz dir compares identical to original storer dir' do
    #o) call zip on zipper-server
    #o) untar
    #o) compare the untarred dir in tmp_zipper to the master
    #   in kata-container volume.

  end

  private

  def expected_error_message
    [
      'ZipperService',
      'zip',
      'StorerService',
      'kata_manifest',
      'Storer',
      'invalid kata_id'
    ].join(':')
  end

end

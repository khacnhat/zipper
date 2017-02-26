require_relative 'test_base'

class ZipTagTest < TestBase

  def self.hex_prefix; '7C880'; end

  test '2A4',
  'zip_tag empty kata_id raises' do
    error = assert_raises(StandardError) {
      zip_tag(kata_id = ' ', 'salmon', 2) }
    assert_equal 'ZipperService:zip_tag:Zipper:invalid kata_id', error.message
  end

end
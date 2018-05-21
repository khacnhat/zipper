require_relative 'test_base'

class ZipTagTest < TestBase

  def self.hex_prefix
    '7C880'
  end

  # - - - - - - - - - - - - - - - - - - - - - - - -

  test '2A4',
  'zip_tag raises when kata_id is malformed' do
    error = assert_raises(StandardError) {
      zip_tag(kata_id = '', 'salmon', 2)
    }
    assert error.message.end_with?('kata_id:malformed'), error.message
  end

  # - - - - - - - - - - - - - - - - - - - - - - - -

  def zip_tag(kata_id, avatar_name, tag)
    zipper.zip_tag(kata_id, avatar_name, tag)
  end

end

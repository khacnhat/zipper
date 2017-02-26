require_relative 'zipper_test_base'
require_relative '../../src/id_splitter'

class ZipTagTest < ZipperTestBase

  def self.hex_prefix; '0AA'; end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test '885',
  'zip_tag with empty id raises' do
    error = assert_raises(StandardError) {
      zip_tag(id = '', 'salmon', 1)
    }
    assert_equal 'Zipper:invalid kata_id', error.message
  end

end

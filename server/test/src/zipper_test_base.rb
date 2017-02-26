require_relative '../hex_mini_test'
require_relative '../../src/externals'

class ZipperTestBase < HexMiniTest

  include Externals

  def zip(kata_id)
    zipper.zip(kata_id)
  end

  def zip_tag(kata_id, avatar_name, tag)
    zipper.zip_tag(kata_id, avatar_name, tag)
  end

end

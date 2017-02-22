require_relative '../hex_mini_test'
require_relative '../../src/externals'

class ZipperTestBase < HexMiniTest

  include Externals

  def zip(id)
    zipper.zip(id)
  end

end

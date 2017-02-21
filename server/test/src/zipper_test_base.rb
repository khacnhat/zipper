require_relative '../hex_mini_test'
require_relative '../../src/externals'

class ZipperTestBase < HexMiniTest

  include Externals

  def zip_json(id)
    zipper.zip_json(id)
  end

  def zip_git(id)
    zipper.zip_git(id)
  end

end

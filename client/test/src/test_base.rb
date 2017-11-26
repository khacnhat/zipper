require_relative 'hex_mini_test'
require_relative '../../src/zipper_service'

class TestBase < HexMiniTest

  def zipper
    ZipperService.new
  end

end

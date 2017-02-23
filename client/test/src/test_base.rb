require_relative '../hex_mini_test'
require_relative '../../src/zipper_service'

class TestBase < HexMiniTest

  def zip(kata_id)
    ZipperService.new.zip(kata_id)
  end

end

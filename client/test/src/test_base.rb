require_relative '../hex_mini_test'
require_relative '../../src/zipper_service'

class TestBase < HexMiniTest

  def zip(kata_id)
    ZipperService.new.zip(kata_id)
  end

  def zip_tag(kata_id, avatar_name, tag)
    ZipperService.new.zip_tag(kata_id, avatar_name, tag)
  end

end

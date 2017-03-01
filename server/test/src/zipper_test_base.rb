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

  def ids
    [
      # C (gcc), assert [no progress_regexs]
      'DADD67B4EF', # empty kata
      'F6986222F0', # (spider) no traffic-lights
      '1D1B0BE42D', # (hippo) one traffic-lights
      '697C14EDF4', # (turtle) three traffic-lights
      '7AF23949B7', # (alligator,heron,squid) each with three traffic-lights
      # C (gcc), CppUTest [has progress_regexs]
      '9EEBD21136', # (turtle) three traffic-lights
    ]
  end

end

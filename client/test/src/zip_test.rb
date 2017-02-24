require_relative 'test_base'

class ZipTest < TestBase

  def self.hex_prefix; 'CE167'; end

  test '8BE',
  'zip empty kata_id raises' do
    error = assert_raises(StandardError) { zip(kata_id = ' ') }
    assert_equal 'ZipperService:zip:Zipper:invalid kata_id', error.message
  end

  # - - - - - - - - - - - - - - - - - - - - - - - -

  test '8BF',
  'zip bad kata_id raises' do
    error = assert_raises(StandardError) { zip(kata_id = 'XX') }
    assert_equal 'ZipperService:zip:Zipper:invalid kata_id', error.message
  end

  # - - - - - - - - - - - - - - - - - - - - - - - -

  test '6F8',
  'unzipped tgz dir compares identical to original storer dir' do
    tgz_filename = zip(kata_id = '7AF23949B7')
    Dir.mktmpdir('zipper') do |tmp_dir|
      system("cd #{tmp_dir} && cat #{tgz_filename} | tar xfz -")
      assert_equal 0, $?.exitstatus
      katas_dir = ENV['CYBER_DOJO_KATAS_ROOT']
      system("diff -rq #{tmp_dir}/7A #{katas_dir}/7A")
      assert_equal 0, $?.exitstatus
    end
  end

end

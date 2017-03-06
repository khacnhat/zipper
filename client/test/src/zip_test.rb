require 'base64'
require_relative 'test_base'

class ZipTest < TestBase

  def self.hex_prefix; 'CE167'; end

  test '8BE',
  'zip empty kata_id raises' do
    error = assert_raises(StandardError) { zip(kata_id = ' ') }
    assert error.message.end_with?('invalid kata_id'), error.message
  end

  # - - - - - - - - - - - - - - - - - - - - - - - -

  test '8BF',
  'zip bad kata_id raises' do
    error = assert_raises(StandardError) { zip(kata_id = 'XX') }
    assert error.message.end_with?('invalid kata_id'), error.message
  end

  # - - - - - - - - - - - - - - - - - - - - - - - -

  test '6F8',
  'unzipped tgz compares identical to original storer dir' do
    encoded = zip(kata_id = '7AF23949B7')

    Dir.mktmpdir('zipper') do |tmp_dir|
      tgz_filename = "#{tmp_dir}/#{kata_id}.tgz"
      File.open(tgz_filename, 'wb') { |file| file.write(Base64.decode64(encoded)) }

      system("cd #{tmp_dir} && cat #{tgz_filename} | tar xfz -")
      assert_equal 0, $?.exitstatus
      katas_dir = ENV['CYBER_DOJO_KATAS_ROOT']
      system("diff -rq #{tmp_dir}/7A #{katas_dir}/7A")
      assert_equal 0, $?.exitstatus
    end
  end

  # - - - - - - - - - - - - - - - - - - - - - - - -

  def zip(kata_id)
    zipper.zip(kata_id)
  end

end

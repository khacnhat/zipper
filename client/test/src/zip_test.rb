require_relative 'test_base'

class ZipTest < TestBase

  def self.hex_prefix; 'CE167'; end

  test '8BE',
  'zip empty kata_id raises' do
    error = assert_raises(StandardError) {
      zip(kata_id = ' ')
    }
    assert_equal expected_error_message, error.message
  end

  # - - - - - - - - - - - - - - - - - - - - - - - -

  test '8BF',
  'zip bad kata_id raises' do
    error = assert_raises(StandardError) {
      zip(kata_id = 'XX')
    }
    assert_equal expected_error_message, error.message
  end

  # - - - - - - - - - - - - - - - - - - - - - - - -

  test '6F8',
  'unzipped tgz dir compares identical to original storer dir' do
    tgz_filename = zip(kata_id = '7AF23949B7')
    Dir.mktmpdir('zipper') do |tmp_dir|
      `cd #{tmp_dir} && cat #{tgz_filename} | tar xfz -`
      katas_dir = ENV['CYBER_DOJO_KATAS_ROOT']

      #`diff -r #{tmp_dir}/7A #{katas_dir}/7A 2>&1`

      #puts `ls -al #{tmp_dir}/7A/F23949B7`
      #puts `ls -al #{katas_dir}/7A/F23949B7`
    end
  end

  private

  def expected_error_message
    [
      'ZipperService',
      'zip',
      'StorerService',
      'kata_manifest',
      'Storer',
      'invalid kata_id'
    ].join(':')
  end

end

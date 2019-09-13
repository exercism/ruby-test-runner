gem 'minitest'

require "minitest/autorun"
require "mocha/setup"

class Minitest::Test
  SAFE_WRITE_PATH = Pathname.new('/tmp')
end

class Minitest::Test
  def tmp_dir_for_fixture(fixture)
    original_path = File.expand_path(File.dirname(__FILE__)) + "/../test/fixtures/#{fixture}/"
    tmp_path = SAFE_WRITE_PATH / SecureRandom.uuid
    FileUtils.cp_r(original_path + "*.rb", tmp_path)

    begin
      yield(tmp_path)
    ensure
      FileUtils.rmdir(tmp_path)
    end
  end
end

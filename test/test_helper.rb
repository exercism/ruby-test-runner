gem 'minitest'

require "minitest/autorun"
require "mocha/setup"

require 'securerandom'

class Minitest::Test
  SAFE_WRITE_PATH = Pathname.new('/tmp')
end

class Minitest::Test
  def run_test_runner(dir)
    system("bin/run.sh two_fer #{dir}", out: "/dev/null", err: "/dev/null")
  end

  def with_tmp_dir_for_fixture(fixture)
    original_path = File.expand_path(File.dirname(__FILE__)) + "/fixtures/#{fixture}/"
    tmp_path = SAFE_WRITE_PATH / SecureRandom.uuid
    FileUtils.mkdir(tmp_path)
    FileUtils.cp_r(Dir.glob(original_path + "*.rb"), tmp_path)

    begin
      yield(tmp_path)
    ensure
      FileUtils.rm_f(tmp_path)
    end
  end
end

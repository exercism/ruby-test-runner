gem 'minitest'

require "minitest/autorun"
require "mocha/setup"

require 'securerandom'
require 'json'

class Minitest::Test
  SAFE_WRITE_PATH = Pathname.new('/tmp')
end

class Minitest::Test

  def assert_fixture(fixture, expected)
    with_tmp_dir_for_fixture(fixture) do |path|
      actual = JSON.parse(File.read(path / "report.json"))
      assert_equal JSON.parse(expected.to_json), actual
    end
  end

  def with_tmp_dir_for_fixture(fixture)
    original_path = File.expand_path(File.dirname(__FILE__)) + "/fixtures/#{fixture}/"
    tmp_path = SAFE_WRITE_PATH / SecureRandom.uuid
    FileUtils.mkdir(tmp_path)
    FileUtils.cp_r(original_path + "iteration/", tmp_path)

    begin
      run_test_runner(tmp_path)
      yield(tmp_path)
    ensure
      FileUtils.rm_f(tmp_path)
    end
  end

  def run_test_runner(dir)
    # Testing commands
    #exec("bin/run.sh two_fer #{dir}")
    #system("bin/run.sh two_fer #{dir}")

    # Main command
    system("bin/run.sh two_fer #{dir}", out: "/dev/null", err: "/dev/null")
  end
end

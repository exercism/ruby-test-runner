# This must happen above the env require below
if ENV["CAPTURE_CODE_COVERAGE"]
  require 'simplecov'
  SimpleCov.start
end

gem 'minitest'

require "minitest/autorun"
require "minitest/pride"
require "mocha/minitest"

require 'securerandom'
require 'json'
require 'English'
require 'pathname'

class Minitest::Test
  SAFE_WRITE_PATH = Pathname.new('/tmp')
end

class Minitest::Test
  def run_fixture(fixture)
    with_tmp_dir_for_fixture(fixture) do |_input_dir, output_dir|
      JSON.parse(File.read(output_dir / "results.json"))
    end
  end

  def assert_fixture(fixture, expected)
    actual = run_fixture(fixture)
    assert_equal JSON.parse(expected.to_json), actual
    assert_test_run_exited_cleanly
  end

  def assert_test_run_exited_cleanly
    assert_equal 0, $CHILD_STATUS.exitstatus
  end

  def refute_test_run_exited_cleanly
    refute_equal 0, $CHILD_STATUS.exitstatus
  end

  def with_tmp_dir_for_fixture(fixture)
    tmp_path = SAFE_WRITE_PATH / SecureRandom.uuid
    input_dir = tmp_path / "input"
    output_dir = tmp_path / "output"
    FileUtils.mkdir_p(input_dir)
    FileUtils.mkdir_p(output_dir)
    FileUtils.copy_entry("#{__dir__}/fixtures/#{fixture}/input", input_dir)

    begin
      run_test_runner(input_dir, output_dir)
      yield(input_dir, output_dir)
    ensure
      FileUtils.rm_f(tmp_path)
    end
  end

  def run_test_runner(input_dir, output_dir)
    # Testing commands
    # exec("bin/run.sh two_fer #{input_dir} #{output_dir}")
    # system("bin/run.sh two_fer #{input_dir} #{output_dir}")

    # Production command
    system("bin/run.sh two_fer #{input_dir} #{output_dir}", out: "/dev/null", err: "/dev/null")
  end
end

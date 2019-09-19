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
    with_tmp_dir_for_fixture(fixture) do |input_dir, output_dir|
      actual = JSON.parse(File.read(output_dir / "results.json"))
      assert_equal JSON.parse(expected.to_json), actual
    end
  end

  def with_tmp_dir_for_fixture(fixture)
    original_path = File.expand_path(File.dirname(__FILE__)) + "/fixtures/#{fixture}/"
    tmp_path = SAFE_WRITE_PATH / SecureRandom.uuid
    input_dir = tmp_path / "input"
    output_dir = tmp_path / "output"
    FileUtils.mkdir_p(input_dir)
    FileUtils.mkdir_p(output_dir)
    FileUtils.copy_entry(original_path + "input", input_dir)

    begin
      run_test_runner(input_dir, output_dir)
      yield(input_dir, output_dir)
    ensure
      FileUtils.rm_f(tmp_path)
    end
  end

  def run_test_runner(input_dir, output_dir)
    # Testing commands
    #exec("bin/run.sh two_fer #{input_dir} #{output_dir}")
    #system("bin/run.sh two_fer #{input_dir} #{output_dir}")

    # Main command
    system("bin/run.sh two_fer #{input_dir} #{output_dir}", out: "/dev/null", err: "/dev/null")
  end
end

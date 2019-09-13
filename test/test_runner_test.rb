require "test_helper"

class TestRunnerTest < Minitest::Test
  def test_exception
    with_tmp_dir_for_fixture('exception') do |path|
      run_test_runner(path)
    end
  end
  def test_pass
    with_tmp_dir_for_fixture('pass') do |path|
      run_test_runner(path)
    end
  end
end

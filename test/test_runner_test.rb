require "test_helper"

class TestRunnerTest < Minitest::Test
  def test_experiments
    with_tmp_dir_for_fixture('pass') do |path|
      TestRunner.run('two-fer', path)
    end
  end
end


require "test_helper"

class TestRunnerTest < Minitest::Test
  def test_exception
    with_tmp_dir_for_fixture(:exception) do |path|
      actual = JSON.parse(File.read(path / "report.json"))
      assert_equal "error", actual["status"]

      assert actual['error'].include?(%q{undefined local variable or method `raise_an_error_because_i_am_a_random_method' for main:Object (NameError)})
      assert actual['error'].include?(%Q{\n\tfrom bin/run.rb:3:in `<main>'\n})
    end
  end

  def test_pass
    assert_fixture(:pass, {
      status: :unknown,
      error: nil,
      tests: []
    })
  end
end

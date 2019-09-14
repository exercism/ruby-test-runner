require "test_helper"

class TestRunnerTest < Minitest::Test
  def test_pass
    assert_fixture(:pass, {
      status: :pass,
      error: nil,
      tests: [
        {name: :test_a_name_given, status: :pass},
        {name: :test_another_name_given, status: :pass},
        {name: :test_no_name_given, status: :pass}
      ]
    })
  end

  def test_fail
    assert_fixture(:fail, {
      status: :fail,
      error: nil,
      tests: [
        {name: :test_a_name_given, status: :pass},
        {name: :test_another_name_given, status: :pass},
        {name: :test_no_name_given, status: :fail, message: %Q{Expected: \"One for you, one for me.\"\n  Actual: \"One for fred, one for me.\"}}
      ]
    })
  end

  def test_exception
    with_tmp_dir_for_fixture(:exception) do |path|
      actual = JSON.parse(File.read(path / "results.json"))
      assert_equal "error", actual["status"]

      assert actual['error'].include?(%q{undefined local variable or method `raise_an_error_because_i_am_a_random_method' for main:Object (NameError)})
      assert actual['error'].include?(%Q{\n\tfrom bin/run.rb:3:in `<main>'\n})
    end
  end
end

require "test_helper"

class TestRunnerTest < Minitest::Test
  def test_pass
    assert_fixture(:pass, {
      status: :pass,
      message: nil,
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
      message: nil,
      tests: [
        {name: :test_a_name_given, status: :pass},
        {name: :test_another_name_given, status: :pass},
        {name: :test_no_name_given, status: :fail, message: %Q{We tried running `TwoFer.two_fer` but received an unexpected result.\nExpected: \"One for you, one for me.\"\n  Actual: \"One for fred, one for me.\"}}
      ]
    })
  end

  def test_exception
    with_tmp_dir_for_fixture(:exception) do |input_dir, output_dir|
      actual = JSON.parse(File.read(output_dir / "results.json"))
      assert_equal "error", actual["status"]

      assert actual['message'].include?(%q{undefined local variable or method `raise_an_error_because_i_am_a_random_method' for main:Object (NameError)})
      assert actual['message'].include?(%Q{\n\tfrom bin/run.rb:3:in `<main>'\n})
    end
  end

  def test_syntax_errors_in_tests
    with_tmp_dir_for_fixture(:syntax_error_in_tests) do |input_dir, output_dir|
      actual = JSON.parse(File.read(output_dir / "results.json"))
      assert_equal "error", actual["status"]

      assert actual['message'].include?(%q{expecting end-of-input (SyntaxError)})
      assert actual['message'].include?(%Q{\n\tfrom bin/run.rb:3:in `<main>'\n})
    end
  end

  def test_syntax_errors_in_code
    with_tmp_dir_for_fixture(:syntax_error_in_code) do |input_dir, output_dir|
      actual = JSON.parse(File.read(output_dir / "results.json"))
      assert_equal "error", actual["status"]

      assert actual['message'].include?(%q{expecting end-of-input (SyntaxError)})
      assert actual['message'].include?(%Q{\n\tfrom bin/run.rb:3:in `<main>'\n})
    end
  end
end

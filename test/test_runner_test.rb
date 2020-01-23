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
        {
          name: :test_a_name_given, 
          status: :pass,
          output: "The name is Alice.\nHere's another line.\n"
        },
        {
          name: :test_another_name_given, 
          status: :pass,
          output: "The name is Bob.\nHere's another line.\n"
        },
        {
          name: :test_no_name_given,
          status: :fail,
          message: %Q{We tried running `TwoFer.two_fer` but received an unexpected result.\nExpected: \"One for you, one for me.\"\n  Actual: \"One for fred, one for me.\"},
          output: "The name is fred.\nHere's another line.\n"
        }
      ]
    })
  end

  def test_deep_exception
    message = %q{
NoMethodError: undefined method `non_existant_method' for nil:NilClass

Traceback (most recent call first):
    Line 8:in `work_out_name'
    Line 3:in `two_fer'
}.strip

    assert_fixture(:deep_exception, {
      status: :fail,
      message: nil,
      tests: [
        {name: :test_no_name_given, status: :fail, message: message}
      ]
    })
  end

  def test_name_error_exception
    with_tmp_dir_for_fixture(:exception) do |input_dir, output_dir|
      actual = JSON.parse(File.read(output_dir / "results.json"))
      assert_equal "error", actual["status"]

      expected = %q{Line 3: undefined local variable or method `raise_an_error_because_i_am_a_random_method' for main:Object (NameError)}
      assert_equal expected, actual['message']

      assert_test_run_exited_cleanly
    end
  end

  def test_syntax_errors_in_tests
    with_tmp_dir_for_fixture(:syntax_error_in_tests) do |input_dir, output_dir|
      actual = JSON.parse(File.read(output_dir / "results.json"))
      assert_equal "error", actual["status"]
      expected = <<EOS
Line 3: syntax error, unexpected ',', expecting end-of-input
,'This is meant to be a syntax...
^
EOS
      assert_equal expected.strip, actual['message']

      assert_test_run_exited_cleanly
    end
  end

  def test_syntax_errors_in_code
    with_tmp_dir_for_fixture(:syntax_error_in_code) do |input_dir, output_dir|
      actual = JSON.parse(File.read(output_dir / "results.json"))
      assert_equal "error", actual["status"]

      expected = <<EOS
Line 2: syntax error, unexpected ',', expecting end-of-input
end,A stray comma
   ^
EOS
      assert_equal expected.strip, actual['message']

      assert_test_run_exited_cleanly
    end
  end

  def test_really_bad_things_exit_uncleanly
    # I have no idea how to make this work, but
    # it seems like a important test to have
    #WriteReport.stubs(:new).raises("Something really bad!")
    #refute_test_run_exited_cleanly
  end
end

require "test_helper"

class TestRunnerTest < Minitest::Test
  def test_pass
    assert_fixture(
      :pass,
      {
        version: 2,
        status: :pass,
        message: nil,
        tests: [
          {
            name: "No name given",
            status: :pass,
            test_code: %(assert_equal "One for you, one for me.", TwoFer.two_fer)
          },
          {
            name: 'A name given',
            test_code: 'assert_equal "One for Alice, one for me.", TwoFer.two_fer("Alice")',
            status: :pass
          },
          {
            name: "Another name given",
            status: :pass,
            test_code: 'assert_equal "One for Bob, one for me.", TwoFer.two_fer("Bob")'
          }
        ]
      }
    )
  end

  def test_pass_ruby_3
    assert_fixture(
      :pass_ruby_3_syntax,
      {
        version: 2,
        status: :pass,
        message: nil,
        tests: [
          {
            name: "Rightward assign",
            status: :pass,
            test_code: %(assert_equal Ruby3Syntax.rightward_assign, 'is fun')
          },
          {
            name: "Endless method def",
            status: :pass,
            test_code: %(assert_equal Ruby3Syntax.endless_methods, 'are fun')
          }
        ]
      }
    )
  end

  def test_fail
    assert_fixture(
      :fail, {
        version: 2,
        status: :fail,
        message: nil,
        tests: [
          {
            name: "No name given",
            test_code: %(assert_equal "One for you, one for me.", TwoFer.two_fer),
            status: :fail,
            message: %(Expected: \"One for you, one for me.\"\n  Actual: \"One for fred, one for me.\"),
            output: "The name is fred.\nHere's another line.\n"
          },
          {
            name: "A name given",
            test_code: 'assert_equal "One for Alice, one for me.", TwoFer.two_fer("Alice")',
            status: :pass,
            output: "The name is Alice.\nHere's another line.\n"
          },
          {
            name: "Another name given",
            test_code: 'assert_equal "One for Bob, one for me.", TwoFer.two_fer("Bob")',
            status: :pass,
            output: "The name is Bob.\nHere's another line.\n"
          }
        ]
      }
    )
  end

  def test_deep_exception
    message = "
NoMethodError: undefined method `non_existant_method' for nil

Traceback (most recent call first):
    Line 8:in `work_out_name'
    Line 3:in `two_fer'
".strip

    assert_fixture(
      :deep_exception,
      {
        version: 2,
        status: :fail,
        message: nil,
        tests: [
          {
            name: "No name given",
            test_code: 'assert_equal "One for you, one for me.", TwoFer.two_fer',
            status: :error,
            message:
          }
        ]
      }
    )
  end

  def test_name_error_exception
    with_tmp_dir_for_fixture(:exception) do |_input_dir, output_dir|
      actual = JSON.parse(File.read(output_dir / "results.json"))
      assert_equal "error", actual["status"]

      expected = "Line 3: undefined local variable or method `raise_an_error_because_i_am_a_random_method' for main (NameError)"
      assert_equal expected, actual['message']

      assert_test_run_exited_cleanly
    end
  end

  def test_syntax_errors_in_tests
    with_tmp_dir_for_fixture(:syntax_error_in_tests) do |_input_dir, output_dir|
      actual = JSON.parse(File.read(output_dir / "results.json"))
      assert_equal "error", actual["status"]
      expected = <<~SYNTAX_ERRORS
        Line 3: syntax error, unexpected ','
        ,'This is meant to be a syntax...
        ^
      SYNTAX_ERRORS
      assert_equal expected, actual['message']

      assert_test_run_exited_cleanly
    end
  end

  def test_syntax_errors_in_code
    with_tmp_dir_for_fixture(:syntax_error_in_code) do |_input_dir, output_dir|
      actual = JSON.parse(File.read(output_dir / "results.json"))
      assert_equal "error", actual["status"]

      expected = <<~SYNTAX_ERRORS
        Line 2: syntax error, unexpected ',', expecting end-of-input
        end,A stray comma
           ^
      SYNTAX_ERRORS
      assert_equal expected, actual['message']

      assert_test_run_exited_cleanly
    end
  end

  def test_really_bad_things_exit_uncleanly
    skip
    # I have no idea how to make this work, but
    # it seems like a important test to have
    # WriteReport.stubs(:new).raises("Something really bad!")
    # refute_test_run_exited_cleanly
  end
end

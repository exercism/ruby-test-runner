require "test_helper"

class AttacksTest < Minitest::Test
  def test_large_output_is_truncated
    assert_fixture(
      :attack_large_output, {
        status: :fail,
        message: nil,
        tests: [
          {
            name: :no_name_given,
            test_code: 'assert_equal "One for you, one for me.", TwoFer.two_fer',
            status: :fail,
            output: %(#{Array.new(500) { 'a' }.join}\n\n...Output was truncated. Please limit to 500 chars...),
            message: "Expected: \"One for you, one for me.\"\n  Actual: false"
          }
        ]
      }
    )
  end
end

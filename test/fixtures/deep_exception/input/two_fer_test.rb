require 'minitest/autorun'
require_relative 'two_fer'

# Common test data version: 1.2.0 4fc1acb
class TwoFerTest < Minitest::Test

  def test_no_name_given
    assert_equal "One for you, one for me.", TwoFer.two_fer, %q{We tried running `TwoFer.two_fer` but received an unexpected result}
  end
end


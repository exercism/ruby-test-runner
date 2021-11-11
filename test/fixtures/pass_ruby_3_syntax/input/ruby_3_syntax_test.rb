require 'minitest/autorun'
require_relative 'ruby_3_syntax'

# minimal set of:
# Common test data version: 1.6.0 42b9d45
class Ruby3SyntaxTest < Minitest::Test
  def test_rightward_assign
    assert_equal Ruby3Syntax.rightward_assign, 'is fun'
  end

  def test_endless_method_def
    assert_equal Ruby3Syntax.endless_methods, 'are fun'
  end
end

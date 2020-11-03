require "test_helper"
require 'test_runner'

class ExtractMetadataTest < Minitest::Test
  def test_assert
    expected = [{
      test: "test_assert_works_properly",
      name: "assert_works_properly",
      cmd: "something = \"Something\"\nsomething.present?",
      expected: true
    }]
    
    actual = TestRunner::ExtractMetadata.(File.expand_path("fixtures/assertions/assert.rb", __dir__))
    assert_equal expected, actual
  end

  def test_refute
    expected = [{
      test: "test_refute_works_properly",
      name: "refute_works_properly",
      cmd: "something = \"Something\"\nsomething.nil?",
      expected: false
    }]
    
    actual = TestRunner::ExtractMetadata.(File.expand_path("fixtures/assertions/refute.rb", __dir__))
    assert_equal expected, actual
  end

  def test_assert_equal
    expected = [{
      test: "test_assert_equal_works_properly",
      name: "assert_equal_works_properly",
      cmd: "some_result = TwoFer.two_fer\nsome_result",
      expected: '"One for you, one for me."'
    }]
    
    actual = TestRunner::ExtractMetadata.(File.expand_path("fixtures/assertions/assert_equal.rb", __dir__))
    assert_equal expected, actual
  end

  def test_no_skips
    expected = [{
      test: "test_skip_works_properly",
      name: "skip_works_properly",
      cmd: "something = \"Something\"\nsomething.present?",
      expected: true
    }]
    
    actual = TestRunner::ExtractMetadata.(File.expand_path("fixtures/assertions/skip.rb", __dir__))
    assert_equal expected, actual
  end
end

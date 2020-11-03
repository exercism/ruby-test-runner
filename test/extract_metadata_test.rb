require "test_helper"
require 'test_runner'

class ExtractMetadataTest < Minitest::Test
  def test_assert_equal
    expected = [{
      test: "test_assert_equal_works_properly",
      name: "assert_equal_works_properly",
      test_code: %Q{some_result = TwoFer.two_fer\nassert_equal "One for you, one for me.", some_result},
    }]
    
    actual = TestRunner::ExtractMetadata.(File.expand_path("fixtures/metadata/assert_equal.rb", __dir__))
    assert_equal expected, actual
  end

  def test_no_skips
    expected = [{
      test: "test_skip_works_properly",
      name: "skip_works_properly",
      test_code: "something = \"Something\"\nassert something.present?"
    }]
    
    actual = TestRunner::ExtractMetadata.(File.expand_path("fixtures/metadata/skip.rb", __dir__))
    assert_equal expected, actual
  end

  def test_no_skip_comments
    expected = [{
      test: "test_skip_works_properly",
      name: "skip_works_properly",
      test_code: "something = \"Something\"\nassert something.present?"
    }]
    
    actual = TestRunner::ExtractMetadata.(File.expand_path("fixtures/metadata/skip_comment.rb", __dir__))
    assert_equal expected, actual
  end

end

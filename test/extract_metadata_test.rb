require "test_helper"
require 'test_runner'

class ExtractMetadataTest < Minitest::Test
  def test_assert_equal
    expected = [{
      test: "test_assert_equal_works_properly",
      name: "Assert equal works properly",
      test_code: %(some_result = TwoFer.two_fer\nassert_equal "One for you, one for me.", some_result),
      index: 0
    }]

    actual = TestRunner::ExtractMetadata.(File.expand_path("fixtures/metadata/assert_equal.rb", __dir__))
    assert_equal expected, actual
  end

  def test_no_skips
    expected = [{
      test: "test_skip_works_properly",
      name: "Skip works properly",
      test_code: "something = \"Something\"\nassert something.present?",
      index: 0
    }]

    actual = TestRunner::ExtractMetadata.(File.expand_path("fixtures/metadata/skip.rb", __dir__))
    assert_equal expected, actual
  end

  def test_no_skip_comments
    expected = [{
      test: "test_skip_works_properly",
      name: "Skip works properly",
      test_code: "something = \"Something\"\nassert something.present?",
      index: 0
    }]

    actual = TestRunner::ExtractMetadata.(File.expand_path("fixtures/metadata/skip_comment.rb", __dir__))
    assert_equal expected, actual
  end

  def test_extracting_indices
    expected = [
      {
        test: "test_zebra",
        name: "Zebra",
        test_code: %(some_result = TwoFer.two_fer("zebra")\nassert_equal "One for you, one for zebra.", some_result),
        index: 0
      },
      {
        test: "test_anaconda",
        name: "Anaconda",
        test_code: %(some_result = TwoFer.two_fer("anaconda")\nassert_equal "One for you, one for anaconda.", some_result),
        index: 1
      },
      {
        test: "test_gorilla",
        name: "Gorilla",
        test_code: %(some_result = TwoFer.two_fer("gorilla")\nassert_equal "One for you, one for gorilla.", some_result),
        index: 2
      },
      {
        test: "test_boa",
        name: "Boa",
        test_code: %(some_result = TwoFer.two_fer("boa")\nassert_equal "One for you, one for boa.", some_result),
        index: 3
      }
    ]

    actual = TestRunner::ExtractMetadata.(File.expand_path("fixtures/metadata/indices.rb", __dir__))
    assert_equal expected, actual
  end
end

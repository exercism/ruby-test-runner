class SomeTest < Minitest::Test
  def test_assert_equal_works_properly
    ### task_id: 123
    some_result = TwoFer.two_fer
    assert_equal "One for you, one for me.", some_result
  end
end

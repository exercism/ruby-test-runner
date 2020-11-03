class SomeTest < Minitest::Test
  def test_assert_works_properly
    something = "Something"
    assert something.present?
  end
end

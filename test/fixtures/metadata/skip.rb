class SomeTest < Minitest::Test
  def test_skip_works_properly
    skip
    something = "Something"
    assert something.present?
  end
end


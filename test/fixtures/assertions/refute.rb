class SomeTest < Minitest::Test
  def test_refute_works_properly
    something = "Something"
    refute something.nil?
  end
end

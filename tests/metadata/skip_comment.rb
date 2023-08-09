class SomeTest < Minitest::Test
  def test_skip_works_properly
    #skip
    # skip
    something = "Something"
    assert something.present?
  #   skip
  end
end



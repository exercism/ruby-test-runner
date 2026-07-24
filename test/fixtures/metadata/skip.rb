class SomeTest < Minitest::Test
  def test_skip_works_properly
    ### task_id: 456
    skip
    something = "Something"
    assert something.present?
  end
end


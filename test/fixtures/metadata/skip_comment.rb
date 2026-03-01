class SomeTest < Minitest::Test
  def test_skip_works_properly
    ### task_id: 789
    #skip
    # skip
    something = "Something"
    assert something.present?
  #   skip
  end
end



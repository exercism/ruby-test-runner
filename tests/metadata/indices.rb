class SomeTest < Minitest::Test
  def test_zebra
    some_result = TwoFer.two_fer("zebra")
    assert_equal "One for you, one for zebra.", some_result
  end

  def test_anaconda
    some_result = TwoFer.two_fer("anaconda")
    assert_equal "One for you, one for anaconda.", some_result
  end

  def test_gorilla
    some_result = TwoFer.two_fer("gorilla")
    assert_equal "One for you, one for gorilla.", some_result
  end

  def test_boa
    some_result = TwoFer.two_fer("boa")
    assert_equal "One for you, one for boa.", some_result
  end
end

module Minitest
  module Assertions
    undef_method :skip if method_defined? :skip
    undef_method :diff if method_defined? :diff

    def skip
      # Noop
    end

    # override any fancy diffing tools that might be available on the OS
    # so that everyone who runs the test runner gets the same simple diff
    def diff(exp, act)
      "Expected: #{exp.inspect}\n  Actual: #{act.inspect}"
    end
  end

  class Test
    class << self
      # Nobody sucks, OK?
      alias use_order_dependent_tests! i_suck_and_my_tests_are_order_dependent!
    end
  end
end

module Minitest
  module Assertions
    undef_method :skip if method_defined? :skip

    def skip
      # Noop
    end
  end

  class Test
    include ExercismPlugin

    class << self
      # Nobody sucks, OK?
      alias use_order_dependent_tests! i_suck_and_my_tests_are_order_dependent!
    end
  end
end

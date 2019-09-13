gem 'minitest'
require "minitest/autorun"

require_relative "minitest_ext/exercism_reporter"
require_relative "minitest_ext/exercism_plugin"

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
      alias_method :use_order_dependent_tests!, :i_suck_and_my_tests_are_order_dependent!
    end
  end
end

class TestRunner
  def self.run(exercise, path_to_tests)
    Minitest.extensions << "exercism"
    Minitest::Test.use_order_dependent_tests!

    Dir.glob(path_to_tests + "/*_test.rb").each do |test_file|
      begin
        require test_file
      rescue => e
        ExercismReporter.exception_raised!(e)
        raise e
      end
    end
  end
end

#TestRunner.run("two-fer", "pass")

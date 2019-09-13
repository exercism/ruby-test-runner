gem 'minitest'
require "minitest/autorun"

require_relative "minitest/exercism_reporter"
require_relative "minitest/exercism_plugin"

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

  def self.run(exercise, dir)
    Minitest.extensions << "exercism"
    Minitest::Test.use_order_dependent_tests!

    path_to_tests = File.expand_path(File.dirname(__FILE__)) + "/../test/fixtures/#{solution_id}/two_fer_test.rb"
    require path_to_tests
  end
end

#TestRunner.run("two-fer", "pass")

require 'mandate'
require 'json'

gem 'minitest'
require "minitest/autorun"

require_relative "write_report"

require_relative "minitest_ext/exercism_plugin"
require_relative "minitest_ext/exercism_reporter"
require_relative "minitest_ext/minitest"

class TestRunner
  def self.run(*args)
    new(*args).run
  end

  attr_reader :exercise, :path_to_tests
  def initialize(exercise, path_to_tests)
    @exercise = exercise
    @path_to_tests = path_to_tests
    @reporter = MiniTest::ExercismReporter.init(exercise, path_to_tests)
  end

  def run
    Minitest.extensions << "exercism"
    Minitest::Test.use_order_dependent_tests!

    Dir.glob(path_to_tests + "/iteration/*_test.rb").each do |test_file|
      begin
        require test_file
      rescue => e
        reporter.exception_raised!(e)
        raise e
      end
    end
  end

  private
  attr_reader :reporter
end

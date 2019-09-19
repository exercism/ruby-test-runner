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

  attr_reader :exercise, :input_path
  def initialize(exercise, input_path, output_path)
    @exercise = exercise
    @input_path = input_path
    @reporter = MiniTest::ExercismReporter.init(exercise, output_path)
  end

  def run
    Minitest.extensions << "exercism"
    Minitest::Test.use_order_dependent_tests!

    Dir.glob(input_path + "/*_test.rb").each do |test_file|
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

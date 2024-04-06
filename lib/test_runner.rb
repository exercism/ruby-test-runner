require 'mandate'
require 'json'

gem 'minitest'
require "minitest/autorun"
require "minitest/pride_plugin"

require_relative "write_report"
require_relative "extract_metadata"
require_relative "extract_test_metadata"

require_relative "minitest_ext/extract_standard_exception_error_message"
require_relative "minitest_ext/extract_syntax_exception_error_message"
require_relative "minitest_ext/extract_failure_error_message"

require_relative "minitest_ext/exercism_plugin"
require_relative "minitest_ext/exercism_reporter"
require_relative "minitest_ext/minitest"

require_relative "ext/kernel"

class TestRunner
  def self.run(*args)
    new(*args).run
  end

  attr_reader :exercise, :input_path

  def initialize(exercise, input_path, output_path)
    @exercise = exercise
    @input_path = input_path
    @reporter = Minitest::ExercismReporter.init(exercise, output_path)
  end

  def run
    Minitest.extensions << "exercism"
    Minitest.extensions << "pride"
    Minitest::Test.use_order_dependent_tests!
    Minitest::PrideIO.pride!

    Dir.glob(File.join(input_path, "*_test.rb")).sort.each do |test_file|
      next if test_file.end_with?("_benchmark_test.rb")

      reporter.set_metadata(test_file, ExtractMetadata.(test_file))

      begin
        require test_file
      rescue StandardError, SyntaxError => e
        reporter.exception_raised!(e)
        next
      end
    end
  end

  private
  attr_reader :reporter
end

module Minitest
  class ExercismReporter < AbstractReporter
    class << self
      attr_reader :instance
    end

    def self.init(*args)
      raise "Instance already defined" if @instance

      @instance = new(*args)
    end

    def start; end

    def prerecord(*)
      reset_user_output
    end

    def set_metadata(test_file, metadata)
      @metadata[test_file] = metadata.each_with_object({}) do |md, hash|
        hash[md[:test]] = md
      end
    end

    def record(result)
      test_metadata = metadata[result.source_location.first][result.name]
      tests << TestResult.new(result, user_output, test_metadata)
    end

    def report
      write_report(status, tests: tests.sort_by(&:index).map(&:to_h))
    end

    def status
      tests.all? { |t| t.status == :pass } ? :pass : :fail
    end

    def exception_raised!(e)
      message =
        case e
        when SyntaxError
          ExtractSyntaxExceptionErrorMessage.(e)
        else
          ExtractStandardExceptionErrorMessage.(e)
        end

      write_report(:error, message:)
    end

    def report_written?
      @report_written
    end

    def record_output(*args)
      user_output.puts(*args)
    end

    private
    attr_reader :exercise, :path, :results, :tests, :user_output, :metadata

    def initialize(exercise, path)
      super()

      @exercise = exercise
      @path = path
      @tests = []
      @report_written = false
      @metadata = {}

      reset_user_output
    end

    def write_report(status, tests: nil, message: nil)
      return if report_written?

      TestRunner::WriteReport.(path, status, tests:, message:)
      @report_written = true
    end

    def reset_user_output
      @user_output = StringIO.new
    end

    class TestResult
      def initialize(result, output_stream, metadata)
        @result = result
        @output_stream = output_stream
        @metadata = metadata
      end

      def to_h
        {}.tap do |hash|
          hash[:name]      = metadata[:name]
          hash[:test_code] = metadata[:test_code]
          hash[:status]    = status
          hash[:output]    = output  if attach_output?
          hash[:message]   = message if attach_message?
        end
      end

      def status
        return :error if result.error?

        result.failures.size == 0 ? :pass : :fail
      end

      def index
        metadata[:index]
      end

      private
      attr_reader :result, :output_stream, :metadata

      def attach_output?
        output_stream.length > 0
      end

      def attach_message?
        status != :pass
      end

      def message
        if result.error?
          ExtractFailureErrorMessage.(result.failure)
        else
          result.failure.to_s
        end
      end

      # Output should be restricted to the first 500 chars
      # and an message should be appended if longer.
      def output
        str = output_stream.string
        return str if str.length <= 500

        %(#{str[0, 500]}\n\n...Output was truncated. Please limit to 500 chars...)
      end
    end
  end
end

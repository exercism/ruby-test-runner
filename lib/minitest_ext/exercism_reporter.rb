module MiniTest
  class ExercismReporter < AbstractReporter
    class << self
      attr_reader :instance
    end

    def self.init(*args)
      raise "Instance already defined" if @instance

      @instance = new(*args)
    end

    def initialize
      @report_written = false
    end

    def start
    end

    def record(result)
      if result.failures.size == 0
        test = {
          status: :pass,
          name: result.name,
        }
      else
        message = result.error?? ExtractFailureErrorMessage.(result.failure) :
                                 result.failure.to_s
        test = {
          status: :fail,
          name: result.name,
          message: message
        }
      end

      tests << test
    end

    def report
      write_report(status, tests: tests)
    end

    def status
      tests.all?{|t|t[:status] == :pass} ? :pass : :fail
    end

    def exception_raised!(e)
      message =
        case e
        when SyntaxError
          ExtractSyntaxExceptionErrorMessage.(e)
        else
          ExtractStandardExceptionErrorMessage.(e)
        end

      write_report(:error, message: message)
    end

    def report_written?
      @report_written
    end

    private
    attr_reader :exercise, :path, :results, :tests
    def initialize(exercise, path)
      @exercise = exercise
      @path = path
      @tests = []
      @report_written = false
    end

    def write_report(status, tests: nil, message: nil)
      return if report_written?

      WriteReport.(path, status, tests: tests, message: message)
      @report_written = true
    end
  end
end

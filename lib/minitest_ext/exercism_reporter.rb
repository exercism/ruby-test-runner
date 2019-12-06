module MiniTest
  class ExercismReporter < AbstractReporter
    class << self
      attr_reader :instance
    end

    def self.init(*args)
      raise "Instance already defined" if @instance

      @instance = new(*args)
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
      WriteReport.(path, status, tests: tests)
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

      WriteReport.(path, :error, message: message)
    end

    private
    attr_reader :exercise, :path, :results, :tests
    def initialize(exercise, path)
      @exercise = exercise
      @path = path
      @tests = []
    end
  end
end

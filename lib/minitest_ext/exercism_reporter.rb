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
      status = result.failures.size == 0 ? :pass : :fail

      test = {
        name: result.name,
        status: status,
      }
      test[:message] = result.failures.first if result.failures.size > 0
      tests << test
    end

    def report
      WriteReport.(path, status, tests: tests)
    end

    def status
      tests.all?{|t|t[:status] == :pass} ? :pass : :fail
    end

    def exception_raised!(e)
      WriteReport.(path, :error, message: e.full_message)
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

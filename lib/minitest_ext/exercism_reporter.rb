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
      message = 
        if e.is_a?(SyntaxError)
          "Line #{e.message.split(":").tap(&:shift).join(":")}"
        else
          line = e.backtrace_locations.first.to_s.split(":")[1]
          "Line #{line}: #{e.message} (#{e.class.name})"
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

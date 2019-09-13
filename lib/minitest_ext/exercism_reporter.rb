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
      p "Starting"
    end

    def record(result)
      p result
      #self.results << result
    end

    def report
      WriteReport.(path, :unknown)
      p "Reporting"
    end

    def passed?
    end

    def exception_raised!(e)
      p "HERE!!"
      WriteReport.(path, :error, error: e.full_message)
    end

    private
    attr_reader :exercise, :path, :results
    def initialize(exercise, path)
      @exercise = exercise
      @path = path
    end
  end
end

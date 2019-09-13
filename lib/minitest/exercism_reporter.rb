module Minitest
  class ExercismReporter < AbstractReporter
    attr_accessor :results

    def initialize(io = $stdout, options = {})
      self.results = []
    end

    def start
    end

    def record(result)
      #p result
      self.results << result
    end

    def report
    end

    def passed?
    end
  end
end

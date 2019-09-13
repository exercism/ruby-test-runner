class ExercismReporter < MiniTest::AbstractReporter
  attr_accessor :results

  def initialize(io = $stdout, options = {})
    self.results = []
  end

  def start
    p "Starting"
  end

  def record(result)
    p result
    self.results << result
  end

  def report
    p "Reporting"
  end

  def passed?
  end

  def self.exception_raised!(e)
    # Handle the exception
    #p e
  end
end

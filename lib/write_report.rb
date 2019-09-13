class WriteReport
  include Mandate

  def initialize(path, status, tests: [], error: nil)
    @path = path
    @status = status
    @tests = tests
    @error = error
  end

  def call
    File.write("#{path}/report.json", json)
  end

  private
  attr_reader :path, :status, :error, :tests
  def json
    {
      status: status,
      error: error,
      tests: tests
    }.to_json
  end
end


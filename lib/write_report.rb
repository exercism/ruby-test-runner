class TestRunner
  class WriteReport
    include Mandate

    def initialize(path, status, tests: [], message: nil)
      @path = path
      @status = status
      @tests = tests
      @message = message
    end

    def call
      File.write("#{path}/results.json", "#{json}\n")
    end

    private
    attr_reader :path, :status, :message, :tests

    def json
      {
        version: 2,
        status:,
        message:,
        tests:
      }.to_json
    end
  end
end

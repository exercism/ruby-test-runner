class ExtractStandardExceptionErrorMessage
  include Mandate

  initialize_with :exception

  def call
    "Line #{line_number}: #{exception.message} (#{exception.class.name})"
  end

  def line_number
    exception.backtrace_locations.first.to_s.split(":")[1]
  end
end

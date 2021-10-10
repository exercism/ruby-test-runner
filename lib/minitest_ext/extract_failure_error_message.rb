class ExtractFailureErrorMessage
  include Mandate

  initialize_with :failure

  def call
    message
  end

  memoize
  def message
    parts = failure.message.split("\n")
    err_msg = parts.shift
    trace = parts.select { |line| line.include?(solution_filepath) }.
      map { |line| line.gsub("#{solution_filepath}:", "Line ") }.
      join("\n")
    "#{err_msg}\n\nTraceback (most recent call first):\n#{trace}"
  end

  memoize
  def solution_filepath
    failure.location.split(":").first
  end
end

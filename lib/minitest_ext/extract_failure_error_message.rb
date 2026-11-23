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

  # Minitest 5.27 shortens paths under the working directory in the
  # backtrace, but not in the location, so match the shortened path.
  memoize
  def solution_filepath
    failure.location.split(":").first.delete_prefix("#{Dir.pwd}/")
  end
end

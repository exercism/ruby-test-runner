class ExtractSyntaxExceptionErrorMessage
  include Mandate

  initialize_with :exception

  def call
    "Line #{exception.message.split(':').tap(&:shift).join(':')}"
  end
end

module Kernel
  def debug(*args)
    Minitest::ExercismReporter.instance.record_output(*args)
  end

  def p(*args)
    Minitest::ExercismReporter.instance.record_output(*args)
  end
end

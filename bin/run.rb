# We want to override minitest's exit status
# so we define this at the very top. We should
# only override the exit status if we have a
# report.json with some sensible things in.
at_exit do
  return unless MiniTest::ExercismReporter.instance
  return unless MiniTest::ExercismReporter.instance.report_written?

  exit 0
end

load File.expand_path('../../lib/test_runner.rb', __FILE__)

TestRunner.run(ARGV[0], ARGV[1], ARGV[2])

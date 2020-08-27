module Minitest
  def self.plugin_bogus_options(opts, options); end

  def self.plugin_exercism_init(*)
    self.reporter.reporters.grep(Minitest::Reporter).each do |rep|
      rep.io = File.open(File::NULL, "w")
    end
    self.reporter << ExercismReporter.instance
  end

  module ExercismPlugin
    def before_setup
      super
    end

    def after_setup; end

    def before_teardown; end

    def after_teardown; end
  end
end

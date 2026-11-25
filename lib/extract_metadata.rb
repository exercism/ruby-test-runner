# Prism ships with Ruby, so this needs no gems. Loading it takes a
# fraction of the time of the parser and rubocop-ast gems, which made
# up most of every run's start-up.
require 'prism'

# This class takes a test file, gets its AST, and
# looks for tests (def test_...). Each of these then
# gets passed into the ExtractTestMetadata.() command
# to get its metadata.
class TestRunner
  class ExtractMetadata < Prism::Visitor
    include Mandate

    initialize_with :filepath

    def call
      @filelines = File.readlines(filepath)
      @num_tests = 0
      ast = Prism.parse(filelines.join).value

      @tests = []

      # Visiting the AST calls the visit_def_node method below
      # whenever a `def` node is hit.
      ast.accept(self)

      # We've extracted all the tests, so now return them.
      tests
    end

    def visit_def_node(node)
      return if node.receiver
      return unless node.name.to_s.start_with?("test_")

      tests << ExtractTestMetadata.(filelines, node, @num_tests)
      @num_tests += 1
    end

    private
    attr_reader :filelines, :tests
  end
end

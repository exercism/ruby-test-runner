require 'rubocop/ast'
require 'parser/current'

# This class takes a test file, gets its AST, and
# looks for tests (def test_...). Each of these then
# gets passed into the ExtractTestMetadata.() command
# to get its metadata.
class TestRunner
  class ExtractMetadata < Parser::AST::Processor
    include Mandate

    initialize_with :filepath

    def call
      @filelines = File.readlines(filepath)
      buffer = Parser::Source::Buffer.new('', source: filelines.join)
      builder = RuboCop::AST::Builder.new
      ast = Parser::CurrentRuby.new(builder).parse(buffer)

      @tests = []

      # Process starts an AST parse. Whenever a `def` node is hit
      # the on_def method below is called. This is how AST parsing
      # works via the parser gem.
      process(ast)

      # We've extacted all the tests, so now return them.
      tests
    end

    def on_def(node)
      return unless node.method_name.to_s.start_with?("test_")

      tests << ExtractTestMetadata.(filelines, node)
    end

    private
    attr_reader :filelines, :tests
  end
end

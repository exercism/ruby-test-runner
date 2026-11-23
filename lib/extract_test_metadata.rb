class TestRunner
  class ExtractTestMetadata < Prism::Visitor
    include Mandate

    initialize_with :filelines, :test_node, :index

    def call
      @ignore_line_numbers = []

      # Generate the data by taking a look at the AST.
      # This method causes multiple calls of visit_call_node,
      # one for each time a method is invoked in the test.
      # For example, when we call assert, or skip
      test_node.accept(self)

      # Now all the data is collected, just piece it together
      # into a nice hash which can be merged into the test results
      {
        test: test_identifier,
        name: test_name,
        test_code:,
        index:
      }
    end

    def visit_call_node(node)
      # This method will get called for all the method calls in the test.
      # We only care about skip lines for now, so leave the others alone.
      return super unless node.name == :skip

      # Add any line numbers covered by the skip to the ignore block
      location = node.location
      @ignore_line_numbers += (location.start_line..location.end_line).to_a
    end

    private
    attr_reader :ignore_line_numbers

    memoize
    def test_identifier
      test_node.name.to_s
    end

    # TODO: Make this a bit prettier.
    memoize
    def test_name
      test_node.name.to_s.gsub("test_", "").
        tr("_", " ").capitalize
    end

    # This builds up the command part. Simply put the algorithm is:
    # - All the lines of codes that we haven't chosen to ignore
    # - Plus an bits we've chosen to add back as the test_code part
    memoize
    def test_code
      # Get the lines excluding the first (def) and last (end)
      location = test_node.location
      body_line_numbers = ((location.start_line + 1)..(location.end_line - 1))

      # Map through those lines, skipping any that were
      # part of assertions
      test_code = body_line_numbers.map do |idx|
        next if ignore_line_numbers.include?(idx)

        c = code_for_line(idx)

        # Only return if it's not a skip comment
        c.start_with?(/\s*#\s*skip/) ? nil : c
      end.compact.join("").rstrip

      # Align everything to the left as the final step
      clean_leading_whitespace(test_code)
    end

    # Remove the minimum amount of leading whitespace
    # from all lines
    def clean_leading_whitespace(multiline)
      min = multiline.lines.map { |line| line[/^\s*/].size }.min
      multiline.gsub(/^\s{#{min}}/, '')
    end

    # The parser returns 1-indexed line numbers. This
    # function retrieves them based on their 0-based equiv.
    def code_for_line(one_indexed_idx)
      filelines[one_indexed_idx - 1]
    end
  end
end

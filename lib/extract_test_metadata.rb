class TestRunner
  class ExtractTestMetadata < Parser::AST::Processor
    include Mandate

    initialize_with :filelines, :test_node

    def call
      @ignore_line_numbers = []

      # Generate the data by taking a look at the AST.
      # This method causes multiple calls of the on_send
      # one for each time a method is invoked in the test class.
      # For example, when we call assert, or skip
      process(test_node)

      # Now all the data is collected, just piece it together
      # into a nice hash which can be merged into the test results
      {
        test: test_identifier,
        name: test_name,
        cmd: cmd,
        expected: expected
      }
    end

    def on_send(node)
      # This method will get called for all the nodes that get called on
      # the test class. We only care about a few of these so just leave
      # the other ones alone.
      return unless node.method_name.to_s.start_with?('assert') || 
                    node.method_name.to_s.start_with?('refute') || 
                    node.method_name == :skip

      # If we've hit any of these lines, we ignore them from the output.
      # We then add back the relevant bits below.
      @ignore_line_numbers += (node.first_line..node.last_line).to_a


      case node.method_name
      when :skip
        # Noop - All we want to do is ignore skip lines, 
        # which has already happened above.
      when :assert
        handle_assert(node)
      when :assert_equal
        handle_assert_equal(node)
      when :refute
        handle_refute(node)
      else
        # TODO: Decide how to deal with assertions that
        # we haven't coded for. This should only be a short-term
        # problem as it's not hard to deal with all of them.
        raise "Unknown assertion type"
      end
    end

    private
    attr_reader :expected, :assertion_cmd_part, :ignore_line_numbers

    # For straight asserts, the expected value is always true
    # and the cmd part of the code is always the first child
    def handle_assert(node)
      @assertion_cmd_part = code_for(node.child_nodes.first)
      @expected = true
    end

    # Handling assert_equal means taking the first part as
    # the expected, and the second part as the code for the cmd
    def handle_assert_equal(node)
      # Get the expected from the first arg
      @expected = code_for(node.child_nodes.first)

      # And get the actual from the second arg
      @assertion_cmd_part = code_for(node.child_nodes[1])
    end

    # For straight refutes, the expected value is always false
    # and the cmd part of the code is always the first child
    def handle_refute(node)
      @assertion_cmd_part = code_for(node.child_nodes.first)
      @expected = false
    end

    memoize
    def test_identifier
      test_node.method_name.to_s
    end

    # TODO: Make this a bit prettier.
    memoize
    def test_name
      test_node.method_name.to_s.gsub("test_", "")
    end

    # This builds up the command part. Simply put the algorithm is:
    # - All the lines of codes that we haven't chosen to ignore
    # - Plus an bits we've chosen to add back as the cmd part
    memoize
    def cmd
      # Get the lines excluding the first (def) and last (end)
      body_line_numbers = ((test_node.first_line + 1)..(test_node.last_line - 1))

      # Map through those lines, skipping any that were
      # part of assertionions
      cmd = body_line_numbers.map { |idx|
        code_for_line(idx) unless ignore_line_numbers.include?(idx)
      }.compact.join("")

      # Do this before we add the assertion, which
      # will always be hard-left indented
      cmd = clean_leading_whitespace(cmd)
      cmd += assertion_cmd_part.rstrip
    end

    # Remove the minimum amount of leading whitespace
    # from all lines
    def clean_leading_whitespace(multiline)
      min = multiline.lines.map {|line| line[/^\s*/].size}.min
      multiline.gsub(/^\s{#{min}}/, '')
    end

    # This looks complex, but is very simple. It's extracting the 
    # relevant part of the original code based on the AST position:
    # (first_line:column .. last_line:last_column)
    def code_for(node)
      loc = node.loc

      if loc.first_line == loc.last_line
        line = code_for_line(loc.first_line)
        line[loc.column...loc.last_column]
      else
        locs = (node.loc.first_line..node.last_line)
        first  = code_for_line(locs.shift)[loc.column, -1]
        last   = code_for_line(locs.pop)[0..loc.last_column]
        [first, *locs, last].compact.join("\n").rtrim
      end
    end

    # The parser returns 1-indexed line numbers. This
    # function retreives them based on their 0-based equiv.
    def code_for_line(one_indexed_idx)
      filelines[one_indexed_idx - 1]
    end
  end
end

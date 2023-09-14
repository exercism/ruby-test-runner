# Exercism's Ruby test runner

![Tests](https://github.com/exercism/ruby-test-runner/workflows/Tests/badge.svg)

This is Exercism's test runnner for the Ruby track.

It is run with `./bin/run.sh $EXERCISE $PATH_TO_FILES $PATH_FOR_OUTPUT` read the source code from `$PATH_TO_FILES` and write a JSON file with the test results to to `$PATH_FOR_OUTPUT`.

For example:

```bash
./bin/run.sh two-fer ~/solution-238382y7sds7fsadfasj23j/ ~/solution-238382y7sds7fsadfasj23j/output
```

## Running the tests

Before running the tests, first install the dependencies:

```bash
bundle config set --local with 'test'
bundle install
```

Then, in [test/test_helper.rb](test/test_helper.rb),
comment the "Production command" `system(…)` out
and uncomment either of the "Testing commands".

Lastly, run the following command to run the tests:

```bash
bundle exec rake test
```

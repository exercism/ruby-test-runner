# Exercism's Ruby test runner

![Tests](https://github.com/exercism/ruby-test-runner/workflows/Tests/badge.svg)

This is Exercism's test runnner for the Ruby track.

It is run with `./bin/run.sh $EXERCISM $PATH_TO_FILES` and will write a JSON file with the test results to the same directory.

For example:

```bash
./bin/run.sh two_fer ~/solution-238382y7sds7fsadfasj23j/
```

## Running the tests

Before running the tests, first install the dependencies:

```bash
bundle install
```

Then, run the following command to run the tests:

```bash
bundle exec rake test
```

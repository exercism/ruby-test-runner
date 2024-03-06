require 'minitest/autorun'
require 'minitest/benchmark'
require_relative 'two_fer'

class TwoFerBenchmarkTest < Minitest::Benchmark
  def bench_two_fer
    assert_performance_linear 0.9999 do |n| # n is a range value
      TwoFer.two_fer
    end
  end
end
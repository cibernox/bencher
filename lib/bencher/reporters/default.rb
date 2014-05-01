require 'benchmark' # Ruby's stdlib Benchmark.

RubyBenchmark = Benchmark

module Bencher
  module Reporters

    # Reporter for measuring time. Just a wrapper around ruby's stdlib Benchmark
    #
    class Default
      def bm(*args, &blk)
        $stdout = File.new('/dev/null', 'w')
        $stdout.sync = true
        RubyBenchmark.bm(*args, &blk)
      ensure
        $stdout = STDOUT
      end
    end
  end
end
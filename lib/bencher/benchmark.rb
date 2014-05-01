require "bencher/formatters/irb"
require "bencher/reporters/default"

# Class to be inherited by all benchmarks.
#
# Classes that inherits from this one must implement a `benchmark` method, and
# can optionally implement also `setup` and `tear_down` methods to be run before
# and after the benchmark respectively.
#
# Examples
#
#   class MyBenchmark < Bencher::Benchmark
#     def benchmark(reporter)
#       repetitions = 1_000_000
#
#       reporter.report "#method_a" do
#         repetitions.times do |number|
#           method_a(number)
#         end
#       end
#
#       reporter.report "#method_b" do
#         repetitions.times do |number|
#           method_b(number)
#         end
#       end
#     end
#   end
#
module Bencher
  class Benchmark

    def initialize(formatter = Formatters::Irb.new, reporter = Reporters::Default.new)
      @formatter = formatter
      @reporter  = reporter
    end

    # Public: Prepare the state to the benchmark to run.
    #
    # It can be overriden in subclasses of Bencher::Benchmark.
    def setup; end

    # Public: Clear the state generated during the benchmark.
    #
    # It can be overriden in subclasses of Bencher::Benchmark.
    def tear_down; end

    # Public: Contains the benchmark code.
    #
    # It *must* be overriden in subclasses.
    #
    # reporter - The object that will measure times of your benchmark
    #
    # Returns the measured times of the benchmark.
    def benchmark(reporter); end;

    # Public: Runs the benchmark, including setup and teardown, an reports results.
    #
    # disable_gc - The boolead indicating if GC should be disabled. Defaults to true
    #
    # Examples
    #
    #   sample_benchmark.run
    #   sample_benchmark.run(false)
    #
    def run(disable_gc = true)
      setup
      result = disable_gc ? run_without_gc : run_with_gc
      tear_down
      @formatter.format(result)
    end

    private

    def run_without_gc
      GC.disable
      result, initial_objects, final_objects = run_benchmark
      GC.enable
      result << diff_object_spaces(final_objects, initial_objects)
    end

    def run_with_gc
      result, initial_objects, final_objects = run_benchmark

      result << diff_object_spaces(final_objects, initial_objects)
    end

    def run_benchmark
      initial_objects = ObjectSpace.count_objects
      result = @reporter.bm{ |reporter| benchmark(reporter) }
      final_objects = ObjectSpace.count_objects

      [result, initial_objects, final_objects]
    end

    def diff_object_spaces(final, initial)
      final.each_with_object({}) do |(k, v), hash|
        hash[k] = v - initial[k]
      end
    end
  end
end
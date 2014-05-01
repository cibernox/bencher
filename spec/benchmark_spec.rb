require 'spec_helper'

class SampleBench < Bencher::Benchmark
  attr_reader :setup_moment
  attr_reader :benchmark_moment
  attr_reader :tear_down_moment

  def setup
    @setup_moment = Time.now
  end

  def benchmark(reporter)
    @benchmark_moment = Time.now

    repetitions = 16

    reporter.report do
      str = ''
      repetitions.times { str << 'Na' }
      str << ' Batman!'
    end
  end

  def tear_down
    @tear_down_moment = Time.now
  end
end

describe Bencher::Benchmark do
  let(:sample_bench) { SampleBench.new }

  describe '#run' do
    it 'executes `setup`, `benchmark` and `tear_down` in that order' do
      sample_bench.run
      expect(sample_bench.setup_moment).to be < sample_bench.benchmark_moment
      expect(sample_bench.benchmark_moment).to be < sample_bench.tear_down_moment
    end

    it 'returns an array with the times measurements in the first places' do
      output = sample_bench.run
      output[0..-2].each do |item|
        expect(item).to respond_to 'cstime'
        expect(item).to respond_to 'cutime'
        expect(item).to respond_to 'label'
        expect(item).to respond_to 'real'
        expect(item).to respond_to 'stime'
        expect(item).to respond_to 'total'
        expect(item).to respond_to 'utime'
      end
    end

    it 'returns an a hash with a report of allocated objects during the benchmark' do
      object_space_report = sample_bench.run.last
      expect(object_space_report).to have_key :TOTAL
    end
  end
end
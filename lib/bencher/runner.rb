require 'pathname'
require 'bencher/formatters/cli'

module Bencher

  def self._benchmarks
    @benchmarks ||= []
  end

  class Benchmark
    # Hook to register tests then files are required
    def self.inherited(base)
      Bencher._benchmarks << base
    end
  end

  class Runner
    BENCHMARKS_FILTER = Proc.new do |filename|
      pathname = Pathname.new(filename)
      filename =~ /_benchmark.rb$/ && pathname.file?
    end

    class << self

      def run(path)
        find_filenames(path).each do |filename|
          require filename

          Bencher._benchmarks.size.times do
            benchmark_klass = Bencher._benchmarks.pop
            benchmark_klass.new(Formatters::Cli.new).run
          end
        end

        0
      rescue => e
        puts "exception raised: #{e}"
        1
      end

      private

      def find_filenames(path)
        pathname = Pathname.new(path)
        raise "No such file or folder" unless pathname.exist?

        filenames = if pathname.directory?
          Dir.glob(File.join(path, '/**/*')).select(&BENCHMARKS_FILTER)
        else
          [pathname.expand_path.to_s]
        end
      end
    end

  end
end
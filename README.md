# Bencher

Simple library to run the simples benchmarks possible.

Just measure times and objects allocation.

## Installation

Add this line to your application's Gemfile:

    gem 'bencher'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install bencher

## Usage

You can create benchmarks just writting classes that inherit from
`Bencher::Benchmark`.

Those classes **must** define a `benchmark` method where you place the code to
be measured.

```ruby
class MyBenchmark < Bencher::Benchmark
  def benchmark(reporter)
    repetitions = 1_000_000

    reporter.report "#method_a" do
      repetitions.times do |number|
        method_a(number)
      end
    end

    reporter.report "#method_b" do
      repetitions.times do |number|
        method_b(number)
      end
    end
  end
end
```

You can run the benchmarks from inside the console

```
[1] pry(main)> require_relative "benchmarks/my_benchmark" # => true
[2] pry(main)> LoadSquadBenchmark.new.run
=> [#<Benchmark::Tms:0x007fd2014a29e8
  @cstime=0.0,
  @cutime=0.0,
  @label="#method_a",
  @real=12.972949,
  @stime=0.6799999999999999,
  @total=7.82,
  @utime=7.140000000000001>,
 #<Benchmark::Tms:0x007fd1e2914c70
  @cstime=0.0,
  @cutime=0.0,
  @label="#method_b",
  @real=4.676458,
  @stime=0.28,
  @total=3.5200000000000005,
  @utime=3.24>,
 {:TOTAL=>8858772, :FREE=>-179860, :T_OBJECT=>393666, :T_CLASS=>3577,
  :T_MODULE=>7, :T_FLOAT=>0, :T_STRING=>4047708, ... }
]
```

Or using the command line utility:

```
$ bundle exec bencher benchmarks/
    user     system      total        real
  5.940000   0.550000   6.490000 (  8.107446)
  2.750000   0.260000   3.010000 (  3.564494)
  1.940000   0.290000   2.230000 (  3.160562)
{:TOTAL=>8982685, :T_OBJECT=>393666, :T_CLASS=>3577, :T_MODULE=>7, :T_FLOAT=>0, :T_STRING=>4099013, ...}
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

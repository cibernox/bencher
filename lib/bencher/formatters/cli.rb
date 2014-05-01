module Bencher
  module Formatters

    # Formatter for the command line. It just outputs the result in STDOUT.
    #
    class Cli
      def format(result)
        puts "    user     system      total        real"
        puts result
      end
    end

  end
end
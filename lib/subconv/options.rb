require 'optparse'
require 'ostruct'

#
# command line options parser
#
module Subconv
  class Options
    FORMATS = [:microdvd, :srt]
    DEFAULT_FRAME_RATE = 25

    attr_reader :options

    def initialize(argv)
      @options = parse_options(argv)
    end

    private

    #
    # Return a structure describing the options.
    #
    def parse_options(argv)
      options = OpenStruct.new
      options.output_format = FORMATS.first
      options.frame_rate = BigDecimal(DEFAULT_FRAME_RATE)

      opt_parser = OptionParser.new do |opts|
        opts.banner = 'Usage: subconv [OPTIONS] INPUT OUTPUT'

        opts.separator ''
        opts.separator 'Specific options:'

        opts.on(
          '-f', '--output-format FORMAT', FORMATS, "Output format (#{ FORMATS.join(', ') })"
        ) do |output_format|
          options.output_format = output_format
        end

        opts.on(
          '-r', '--frame-rate [RATE]', String, 'Frame rate (for microdvd)'
        ) do |frame_rate|
          options.frame_rate = BigDecimal.new(frame_rate)
        end

        opts.separator ''
        opts.separator 'Common options:'

        opts.on_tail('-h', '--help', 'Show this message') do
          puts opts
          exit
        end
      end

      begin
        opt_parser.order!(argv) do |arg|
          opt_parser.terminate(arg)  # terminate after the first non-option argument
        end
      rescue OptionParser::ParseError => e
        Util.panic(e.message)
      end

      options
    end
  end
end

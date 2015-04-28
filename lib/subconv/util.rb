require 'optparse'
require 'ostruct'

#
# utilities
#
module Subconv
  module Util
    FORMATS = [:microdvd, :srt]
    DEFAULT_FRAME_RATE = 25

    #
    # Return a structure describing the options.
    #
    def self.parse_options(_args)
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

      opt_parser.order! do |arg|
        opt_parser.terminate(arg)  # terminate after the first non-option argument
      end

      options
    end  # parse_options

    def self.panic(message)
      $stderr.puts message
      exit 1
    end
  end
end

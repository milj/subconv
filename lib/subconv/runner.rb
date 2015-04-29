module Subconv
  class Runner
    def initialize(argv)
      @options = Options.new(argv).options
      @input_filename = argv[0]
      @output_filename = argv[1]

      # TODO: better error handling
      Util.panic('No input file given') if @input_filename.nil? || @input_filename.empty?
      Util.panic('No output file given') if @output_filename.nil? || @output_filename.empty?
    end

    def run
      formatter = Subconv.make_formatter(@options)
      subtitle_set = SubtitleSet.new
      subtitle_set.read(@input_filename)
      subtitle_set.write(formatter, @output_filename)
    end
  end
end

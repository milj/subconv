module Subconv

  #
  # Container for a single subtitle
  #
  class Subtitle

    attr_accessor :start_time, :end_time  # times in seconds
    attr_reader :lines

    def initialize
      @lines = []
    end

    def <<( line )
      @lines << line
    end

  end

end
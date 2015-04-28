module Subconv
  #
  # SRT output formatter
  #
  class SRTFormatter
    def initialize
      @subtitle_counter = 0
    end

    def output_subtitle(subtitle)
      @subtitle_counter += 1
      timecodes = [subtitle.start_time, subtitle.end_time].map do |time|
        SRTFormatter.timecode(time)
      end
      "#{ @subtitle_counter }\n#{ timecodes.join(' --> ') }\n#{ subtitle.lines.join("\n") }\n\n"
    end

    # example SRT timecode: 00:02:17,440  (hours:minutes:seconds,miliseconds)
    def self.timecode(time)  # time is given in seconds
      format(
        '%02d:%02d:%02d,%03d',
        time / 3600,
        (time % 3600) / 60,
        time % 60,
        1000 * (time % 1)
      )
    end
  end
end

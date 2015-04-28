module Subconv
  #
  # MicroDVD output formatter
  #
  class Subconv::MicroDVDFormatter
    def initialize(frame_rate)
      @frame_rate = frame_rate
    end

    def output_subtitle(subtitle)
      start_frame, end_frame = [subtitle.start_time, subtitle.end_time].map { |time| (time * @frame_rate).round }
      "{#{ start_frame }}{#{ end_frame }}#{ subtitle.lines.join('|') }\n"
    end
  end
end

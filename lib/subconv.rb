require 'nokogiri'
require 'bigdecimal'

require 'subconv/subtitle'
require 'subconv/subtitle_set'
require 'subconv/micro_dvd_formatter'
require 'subconv/srt_formatter'
require 'subconv/util'
require 'subconv/version'

module Subconv
  def self.make_formatter(options)  # TODO: proper factory class if needed
    case options.output_format
    when :microdvd
      return Subconv::MicroDVDFormatter.new(options.frame_rate)
    when :srt
      return Subconv::SRTFormatter.new
    end
  end
end

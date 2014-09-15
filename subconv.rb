#!/usr/bin/env ruby

require 'optparse'
require 'ostruct'
require 'nokogiri'
require 'bigdecimal'


#TODO split the code into separate files
#TODO unit tests
#TODO make it a gem
#TODO better error handling
#TODO translate text position and formatting markup
#TODO infer output format from output filename's suffix if not specified


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

end  # Subtitle


#
# Stores the subtitle file
#
class SubtitleSet

  # open the xml, parse and store
  def read( filename )
    File.open( filename, 'r' ) do |file|
      subtitle_nodes = Nokogiri::XML( file ).xpath( '/ttaf:tt/ttaf:body/ttaf:div/ttaf:p', :ttaf => 'http://www.w3.org/2006/04/ttaf1' )
      @subtitles = []
      subtitle_nodes.each do |sn|
        subtitle = Subtitle.new
        subtitle.start_time, subtitle.end_time = [sn['begin'], sn['end']].map { |t| BigDecimal( t ) }
        sn.xpath( './text()' ).each do |txt|
          subtitle << txt.inner_text.strip
        end
        @subtitles << subtitle
      end
    end
    Util.panic( 'No subtitles found' ) if @subtitles.empty?
  rescue Errno::ENOENT
    Util.panic( "No such input file #{ filename }" )
  end

  # write the subtitles, uses the given formatter
  def write( formatter, filename )
    Util.panic( "Output file #{ filename } already exists" ) if File.exist?( filename )
    File.open( filename, 'w' ) do |file|
      @subtitles.each do |sub|
        file.write( formatter.output_subtitle( sub ) )
      end
    end
  end

end  # SubtitleSet


#
# MicroDVD output formatter
#
class MicroDVDFormatter

  def initialize( frame_rate )
    @frame_rate = frame_rate 
  end

  def output_subtitle( subtitle )
    start_frame, end_frame = [subtitle.start_time, subtitle.end_time].map { |time| ( time * @frame_rate ).round }
    return "{#{ start_frame }}{#{ end_frame }}#{ subtitle.lines.join( '|' ) }\n"
  end

end  # MicroDVDFormatter


#
# SRT output formatter
#
class SRTFormatter

  def initialize
    @subtitle_counter = 0
  end

  def output_subtitle( subtitle )
    @subtitle_counter += 1
    timecodes = [subtitle.start_time, subtitle.end_time].map { |time| timecode( time ) }
    return "#{ @subtitle_counter }\n#{ timecodes.join( ' --> ' ) }\n#{ subtitle.lines.join( "\n" ) }\n\n"
  end

  private

  # example SRT timecode: 00:02:17,440  (hours:minutes:seconds,miliseconds)
  def timecode( time )  # time is given in seconds
    return sprintf(
      '%02d:%02d:%02d,%03d',
      time / 3600,
      ( time % 3600 ) / 60,
      time % 60,
      1000 * ( time % 1 )
    )
  end

end  # SRTFormatter


#
# utilities
#
module Util

  FORMATS = [:microdvd, :srt]
  DEFAULT_FRAME_RATE = 25

  #
  # Return a structure describing the options.
  #
  def self.parse_options( args )
    options = OpenStruct.new
    options.output_format = FORMATS.first
    options.frame_rate = BigDecimal( DEFAULT_FRAME_RATE )

    opt_parser = OptionParser.new do |opts|
      opts.banner = 'Usage: subconv [OPTIONS] INPUT OUTPUT'

      opts.separator ''
      opts.separator 'Specific options:'

      opts.on( '-f', '--output-format FORMAT', FORMATS, "Output format (#{ FORMATS.join( ', ' ) })" ) do |output_format|
        options.output_format = output_format
      end

      opts.on( '-r', '--frame-rate [RATE]', String, 'Frame rate (for microdvd)' ) do |frame_rate|
        options.frame_rate = BigDecimal.new( frame_rate )
      end

      opts.separator ''
      opts.separator 'Common options:'

      opts.on_tail( '-h', '--help', 'Show this message') do
        puts opts
        exit
      end
    end

    opt_parser.order! do |arg|
      opt_parser.terminate( arg )  # terminate after the first non-option argument
    end

    return options

  end  # parse_options

  def self.panic( message )
    $stderr.puts message
    exit 1
  end

end  # Util



#
# driver code
#

def make_formatter( options )  #TODO proper factory class if needed
  case options.output_format
  when :microdvd
    return MicroDVDFormatter.new( options.frame_rate )
  when :srt
    return SRTFormatter.new
  end
end

options = Util.parse_options( ARGV )
input_filename = ARGV[0]
output_filename = ARGV[1]
Util.panic( 'No input file given' ) if input_filename.nil? || input_filename.empty?
Util.panic( 'No output file given' ) if output_filename.nil? || output_filename.empty?
formatter = make_formatter( options )

subtitle_set = SubtitleSet.new
subtitle_set.read( input_filename )
subtitle_set.write( formatter, output_filename )

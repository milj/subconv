module Subconv

  #
  # Stores the subtitle file
  #
  class Subconv::SubtitleSet

    attr_reader :subtitles

    # open the xml, parse and store
    def read( filename )
      File.open( filename, 'r' ) do |file|
        subtitle_nodes = Nokogiri::XML( file ).xpath(
          '/ttaf:tt/ttaf:body/ttaf:div/ttaf:p',
          :ttaf => 'http://www.w3.org/2006/04/ttaf1'
        )
        @subtitles = []
        subtitle_nodes.each { |node| @subtitles << SubtitleSet.parse_node( node ) }
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

    def self.parse_node( node )
      subtitle = Subtitle.new
      subtitle.start_time = parse_time( node['begin'] )
      if node['end']
        subtitle.end_time = parse_time( node['end'] )
      elsif node['dur']
        subtitle.end_time = subtitle.start_time + parse_time( node['dur'] )
      else
        Util.panic( 'No end time' )
      end
        node.xpath( './text()' ).each do |txt|
        subtitle << txt.inner_text.strip
      end
      return subtitle
    end

    # returns the number of seconds
    # time_string can be e.g. '00:00:12.300' or '00:00:12' or '00:12' or '1234.5678'
    def self.parse_time( time_string )
      elements = time_string.match( /\A(((\d{2}):)?((\d{2}):))?(\d+(\.\d+)?)?\z/ )
      return { 3 => 3600, 5 => 60, 6 => 1 }.map do |position, multiplier|
        BigDecimal( elements[position] || '' ) * multiplier
      end.reduce( 0 ) { |acc, n| acc + n }
    rescue
      raise 'Malformatted time'
    end

  end

end

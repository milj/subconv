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

  end

end

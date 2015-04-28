require_relative '../test_helper'

class SubtitleSetTest < Test::Unit::TestCase
  def assert_time_parsed(expected, actual)
    assert_equal expected, Subconv::SubtitleSet.parse_time(actual)
  end

  def test_parse_time
    assert_time_parsed 12, '00:00:12'
    assert_time_parsed 12, '00:12'
    assert_time_parsed 12, '12'
    assert_time_parsed 12.3, '00:00:12.300'
    assert_time_parsed 1234.5678, '1234.5678'
    assert_time_parsed 0.123, '0.123'
    assert_time_parsed 3723.4, '01:02:03.4'
    assert_time_parsed 0, '0'
    assert_time_parsed 0, '00'
    assert_raise RuntimeError do
      Subconv::SubtitleSet.parse_time('Abcd')
    end
  end

  def test_subtitle_set_read
    subtitle_set = Subconv::SubtitleSet.new
    subtitle_set.read(File.join(File.dirname(__FILE__), '..', 'fixtures', '1.xml'))
    assert_equal 2, subtitle_set.subtitles.length
  end

  # TODO: test_subtitle_set_write
end

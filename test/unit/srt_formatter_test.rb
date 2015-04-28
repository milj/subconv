require_relative '../test_helper'

class FormatterTest < Test::Unit::TestCase
  include Subconv::TestHelper

  def assert_time_formatted(expected, actual)
    assert_equal expected, Subconv::SRTFormatter.timecode(actual)
  end

  def test_srt_formatter
    setup_subtitle
    formatter = Subconv::SRTFormatter.new
    assert_equal "1\n00:00:01,000 --> 00:00:02,000\nAbc\nDef\n\n", formatter.output_subtitle(@subtitle)
  end

  def test_srt_timecode
    assert_time_formatted '00:00:00,000', 0
    assert_time_formatted '00:00:00,123', 0.123
    assert_time_formatted '00:00:12,000', 12
    assert_time_formatted '00:00:12,300', 12.3
    assert_time_formatted '00:20:34,567', 1234.5678
    assert_time_formatted '01:02:03,400', 3723.4
  end
end

require_relative '../test_helper'

class OptionsTest < Test::Unit::TestCase
  def test_output_format
    opts = Subconv::Options.new(['-f', 'srt'])
    assert_equal :srt, opts.options.output_format
  end

  def test_frame_rate
    opts = Subconv::Options.new(['-r', '29.97'])
    assert_equal 29.97, opts.options.frame_rate
  end
end

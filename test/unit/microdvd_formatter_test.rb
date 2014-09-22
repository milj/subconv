require_relative '../test_helper'

class FormatterTest < Test::Unit::TestCase

  include Subconv::TestHelper

  def test_micro_dvd_formatter
    setup_subtitle
    formatter = Subconv::MicroDVDFormatter.new( 25 )
    assert_equal "{25}{50}Abc|Def\n", formatter.output_subtitle( @subtitle )
  end

end

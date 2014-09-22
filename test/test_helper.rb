require 'minitest/autorun'
require 'test/unit'
require 'subconv'

module Subconv::TestHelper

  def setup_subtitle
    @subtitle = Subconv::Subtitle.new
    @subtitle.start_time = 1
    @subtitle.end_time = 2
    @subtitle << "Abc"
    @subtitle << "Def"
  end

end

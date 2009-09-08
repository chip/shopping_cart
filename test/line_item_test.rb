require File.dirname(__FILE__) + '/test_helper.rb'
# require 'test_helper'

class LineItemTest < ActiveSupport::TestCase
  load_schema
  
  def test_line_item
    assert_kind_of LineItem, LineItem.new 
  end
  
end

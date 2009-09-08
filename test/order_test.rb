require File.dirname(__FILE__) + '/test_helper.rb'
# require 'test_helper'

class OrderTest < ActiveSupport::TestCase
  load_schema
  
  def test_order
    assert_kind_of Order, Order.new 
  end
  
end

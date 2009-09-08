require File.dirname(__FILE__) + '/test_helper.rb'
# require 'test_helper'

class CartTest < ActiveSupport::TestCase
  load_schema
  
  def test_cart
    assert_kind_of Cart, Cart.new 
  end
  
end

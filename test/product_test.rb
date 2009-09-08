require File.dirname(__FILE__) + '/test_helper.rb'
# require 'test_helper'

class ProductTest < ActiveSupport::TestCase
  load_schema
  
  def test_product
    assert_kind_of Product, Product.new 
  end
  
end

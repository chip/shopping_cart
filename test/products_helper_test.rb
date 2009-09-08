require File.dirname(__FILE__) + '/test_helper.rb' 
include ProductsHelper 

class ProductsHelperTest < ActionView::TestCase
  def test_product_image 
    assert_equal image_tag("/images/products/foo.png"), product_image("foo")  
  end 
end 
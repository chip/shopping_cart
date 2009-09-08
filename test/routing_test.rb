require File.dirname(__FILE__) + '/test_helper.rb' 

class RoutingTest < Test::Unit::TestCase 
  def setup 
    ActionController::Routing::Routes.draw do |map| 
      map.resources :products
      map.resources :carts
      map.resources :orders
    end  
  end  
  
  def test_products_route 
    assert_recognition :get, "/products", :controller => "products", :action => "index"  
  end  

  #     assert_recognition :get, "/carts", :controller => "carts", :action => "index"  
#     assert_recognition :get, "/orders", :controller => "orders", :action => "index"  

private 

  def assert_recognition(method, path, options)  
    result = ActionController::Routing::Routes.recognize_path(path, :method => method)  
    assert_equal options, result 
  end
end 
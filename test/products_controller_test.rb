require File.dirname(__FILE__) + '/test_helper.rb' 
require 'products_controller' 

class ProductsController; def rescue_action(e) raise e end; end 

class ProductsControllerTest < ActionController::TestCase
  def setup 
    ActionController::Routing::Routes.draw do |map| 
      map.resources :products
    end
  end  
  
  def test_index 
    get :index  
    assert_response :success  
  end
end 
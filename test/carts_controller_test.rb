require File.dirname(__FILE__) + '/test_helper.rb' 
require 'carts_controller' 

class CartsController; def rescue_action(e) raise e end; end 

class CartsControllerTest < ActionController::TestCase
  def setup 
    ActionController::Routing::Routes.draw do |map| 
      map.current_cart 'cart', :controller => 'carts', :action => 'show', :id => 'current'
      map.resources :carts
    end
  end  
  
  def test_show
    get :show, :id => 'current'
    assert_response :success
    # assert_kind_of Cart, @current_cart
    assert_select "form"
  end
end
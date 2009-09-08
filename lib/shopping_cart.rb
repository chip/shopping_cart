%w{ models controllers helpers }.each do |dir| 
  path = File.join(File.dirname(__FILE__), 'app', dir)  
  $LOAD_PATH << path 
  ActiveSupport::Dependencies.load_paths << path 
  ActiveSupport::Dependencies.load_once_paths.delete(path) 
end

require 'action_view/test_case'
# require "shopping_cart/routing"
require "shopping_cart/commands"
require "shopping_cart_setup"

module ShoppingCart
  def self.included(base)
    base.extend ClassMethods
    # base.helper_method :current_cart, :get_cart
    include InstanceMethods
  end

  module ClassMethods
  end
  
  module InstanceMethods
    def current_cart
      # session[:cart_id] = nil
      logger.info "session[:cart_id]=#{session[:cart_id]}"   
      if session[:cart_id]
        @current_cart ||= Cart.find(session[:cart_id])
        session[:cart_id] = nil if @current_cart.purchased_at
      end
      if session[:cart_id].nil?
        @current_cart = Cart.create!
        session[:cart_id] = @current_cart.id
      end
      @current_cart
    end
  
    def get_cart
      @current_cart = current_cart
      @line_items = @current_cart.line_items
    end
    
    def proceed_to_checkout_link
      get_cart
      unless @line_items.count.zero?
        return '| ' + link_to("Proceed to Checkout", new_order_path)
      end
    end
  end
end
ActionController::Base.send(:include, ShoppingCart)
ActionView::Base.send(:include, ShoppingCart)
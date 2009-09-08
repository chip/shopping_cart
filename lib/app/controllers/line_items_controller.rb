class LineItemsController < ActionController::Base   
  include ShoppingCart
  before_filter :get_cart
  
  def create
    @product = Product.find(params[:product_id])
    if @current_cart.blank? || !LineItem.find(:first, :conditions => ["product_id = ? AND cart_id = ?", @product.id, @current_cart.id])
      @line_item = LineItem.create!(:cart => current_cart, :product => @product, :quantity => 1, :unit_price => @product.price)
    else
      @line_item = LineItem.find(:first, :conditions => ["product_id = ? AND cart_id = ?", @product.id, @current_cart.id])
      @line_item.update_attribute :quantity, @line_item.quantity + 1
    end
    flash[:notice] = "Added #{@product.name} to cart."
    # redirect_to current_cart_url
    redirect_to edit_cart_url(@current_cart)
  end
  
  def destroy
    @line_item = LineItem.first(:conditions => ["cart_id = ? and id = ?", @current_cart.id, params[:id]])
    if @line_item.nil?
      flash[:error] = "Oops!  Item was not deleted."
    else
      @line_item.destroy
    end
    redirect_to edit_cart_path(@current_cart)
  end
  
end

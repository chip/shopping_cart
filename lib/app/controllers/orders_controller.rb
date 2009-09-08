class OrdersController < ActionController::Base   
  include ShoppingCart
  before_filter :get_cart
  layout 'application'
  
  def new
    @order = Order.new(params[:order])
    @order.billing_address = BillingAddress.new(params[:billing_address])

    logger.info "total_price: #{@current_cart.total_price}"
    if @current_cart.total_price.zero?
      flash[:error] = "Please add items to your cart before attempting to complete an order."
      redirect_to cart_url(@current_cart) and return
    end
  end
  
  def create
    @order = current_cart.build_order(params[:order])
    @order.ip_address = request.remote_ip
    @order.billing_address = BillingAddress.new(params[:billing_address])
    
    if @order.save
      if @order.purchase
        Notification.deliver_order(@order)
        render :action => "success"
      else
        logger.info "order errors = #{@order.errors.to_yaml}"
        render :action => "failure"
      end
    else
      render :action => 'new'
    end
  end
end

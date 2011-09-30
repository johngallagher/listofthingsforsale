class OrderFinder
  def initialize(args)
    raise "order_params must not be nil" if args[:order_params].nil?
    @order_params = args[:order_params]
  end
  
  def find_pending
    found_orders = Order.where(query_string).all
    found_orders.first if found_orders
  end
  
  def query_string
    { :status => "Pending", 
      :shop_id => @order_params[:option_selection1_1],
      :buyer_paypal_email => @order_params[:payer_email],
      :total_price => @order_params[:mc_gross],
      :session_id  => @order_params[:session_id]
      }
  end
end
class PaypalParamsToOrderAdapter
  def initialize(paypal_params)
    @paypal_params = paypal_params
  end
  
  def adapt
    @order = Order.new(:shop_id => @paypal_params["option_selection1_1"].to_i, 
    :status => @paypal_params["payment_status"], 
    :session_id => @paypal_params["session_id"],
    :total_price => @paypal_params["mc_gross"],
    :currency => @paypal_params["mc_currency"])
    @order.line_items << LineItem.new()
    @order.line_items << LineItem.new()
    @order    
  end
  
end
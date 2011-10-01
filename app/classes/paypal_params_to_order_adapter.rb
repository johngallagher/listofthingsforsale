class PaypalParamsToOrderAdapter
  def initialize(paypal_params)
    @paypal_params = paypal_params
    create_order
  end
  
  def create_order
    @order = Order.new()
  end
end
class OrderFinder
  def initialize(args)
    @order_params = args[:order_params]
  end
  
  def find_pending
    Order.where(:status => "Pending", :shop_id => @order_params[:option_selection1_1])
  end
end
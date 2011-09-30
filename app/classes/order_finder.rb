class OrderFinder
  def initialize(args)
    raise "order_params must not be nil" if args[:order_params].nil?
    @order_params = args[:order_params]
    @found_orders = nil
  end
  
  def find_pending
    find_orders
    filter_found_orders
    if @found_orders and @found_orders.count == 1
      @found_orders.first 
    else
      nil
    end
  end
  
  def find_orders
    @found_orders = Order.where(query_hash).all
  end
  
  def filter_found_orders
    @found_orders.select! do |order|
      order.line_items.first.item.id == @order_params["option_selection2_1"].to_i
    end
  end
  
  def query_hash
    { 
      :status => "Pending", 
      :shop_id => @order_params["option_selection1_1"].to_i,
      :total_price => BigDecimal.new(@order_params["mc_gross"]),
      :session_id  => @order_params["session_id"]
    }
  end
end
class OrderFinder
  def initialize(args)
    raise "order_params must not be nil" if args[:order_params].nil?
    @order_params = args[:order_params]
  end
  
  def find_pending
    puts "Query string was #{query_string}"
    puts "All Orders were #{Order.all}"
    found_orders = Order.where(query_string).all
    puts "Orders found were #{found_orders}"
    if found_orders and found_orders.count == 1
      found_orders.first 
    else
      nil
    end
  end
  
  def query_string
    { :status => "Pending", 
      :shop_id => @order_params["option_selection1_1"].to_i,
      :total_price => BigDecimal.new(@order_params["mc_gross"]),
      :session_id  => @order_params["session_id"]
    }
  end
  
end
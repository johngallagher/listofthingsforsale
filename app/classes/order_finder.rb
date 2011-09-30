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
      line_items_match?(order.line_items)
    end
  end
  
  def line_items_match?(line_items)
    line_items.each_index do |line_item_index|
      order_line_item_id = line_items[line_item_index].item.id
      params_line_item_id = @order_params["option_selection2_#{line_item_index + 1}"].to_i
      
      return false if order_line_item_id != params_line_item_id
    end
    return true
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
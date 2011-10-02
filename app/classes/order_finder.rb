class OrderFinder
  def initialize(args)
    raise "params_order must not be nil" if args[:params_order].nil?
    @params_order = args[:params_order]
    @found_orders = nil
  end
  
  def find_pending
    find_orders
    # filter_found_orders # For later.
    return nil if @found_orders.nil? or @found_orders.empty?
      
    @found_orders.first 
    # Later
    # if @found_orders.count == 1
    #   @found_orders.first 
    # else
    #   @found_orders
    # end
  end
  
  def find_orders
    @found_orders = Order.where(query_hash).all
  end
  
  def filter_found_orders
    @found_orders.select! do |order|
      line_item_ids_match?(order.line_items)
    end
  end
  
  def line_item_ids_match?(line_items)
    line_items.each_index do |line_item_index|
      order_line_item_id = line_items[line_item_index].item.id
      params_line_item_id = @params_order["option_selection2_#{line_item_index + 1}"].to_i
      
      return false if order_line_item_id != params_line_item_id
    end
    return true
  end
  
  def query_hash
    { 
      :status => Status::Pending, 
      :shop_id => @params_order["option_selection2_1"].to_i,
      :total_price => BigDecimal.new(@params_order["mc_gross"])
    }
  end
end
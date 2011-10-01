class OrderValidator
  def initialize(args)
    raise "params_order must not be nil" if args[:params_order].nil?
    raise "pending_order must not be nil" if args[:pending_order].nil?
    @params_order = args[:params_order]
    @pending_order = args[:pending_order]
  end
  
  def orders_match?
    
  end
  
  def num_cart_items_match?
    @pending_order.line_items.count == @params_order["num_cart_items"].to_i
  end
  

end
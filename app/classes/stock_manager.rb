class StockManager
  def initialize(args)
    @completed_order = args[:completed_order]
  end
  
  def adjust_stock
    @completed_order.line_items.each do |line_item|
      stock_item = line_item.item
      if stock_item.quantity > 0
        stock_item.quantity -= 1
        stock_item.save!
      end
    end
  end
end
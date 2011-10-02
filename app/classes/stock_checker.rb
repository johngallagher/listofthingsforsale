class StockChecker
  def initialize(args)
    @item_id = args[:item_id].to_i
    @quantity_needed = args[:quantity].to_i
  end
  def in_stock?
    @found_item = Item.where(:id => @item_id).first
    if @found_item.nil?
      return false
    else
      @found_item.quantity >= @quantity_needed
    end
  end
end
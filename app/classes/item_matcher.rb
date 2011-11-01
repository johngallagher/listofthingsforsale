class ItemMatcher
  def initialize(args)
    @items = args[:items]
    @criteria = args[:criteria]
  end
  def match
    perfect_item_match = @items.select{ |i| i.name == @criteria[:name] and i.price == @criteria[:price] and i.description_text == @criteria[:description_text] }.first
    return perfect_item_match unless perfect_item_match.nil?
    
    name_and_price_match = @items.select{ |i| i.name == @criteria[:name] and i.price == @criteria[:price]}.first
  end
end
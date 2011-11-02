class ItemMatcher
  def initialize(args)
    @items = args[:items]
    @criteria = args[:criteria]
  end
  def match
    perfect_item_match = @items.select{ |i| i.matches?(@criteria) }.first
    return perfect_item_match unless perfect_item_match.nil?
    
    name_and_price_match = @items.select{ |i| i.name_and_price_match?(@criteria) }.first
    return name_and_price_match unless name_and_price_match.nil?
    
    price_and_description_match = @items.select{ |i| i.price_and_description_match?(@criteria) }.first
    return price_and_description_match unless price_and_description_match.nil?

    name_and_description_match = @items.select{ |i| i.name_and_description_match?(@criteria) }.first
    return name_and_description_match unless name_and_description_match.nil?
  end
end
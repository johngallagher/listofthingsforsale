class ItemMatcher
  def initialize(args)
    @items = args[:items]
    @criteria = args[:criteria]
  end
  def match
    perfect_item_match = @items.select{ |i| i.name == @criteria[:name] and i.price == @criteria[:price] and i.description_text == @criteria[:description_text] }.first
    if perfect_item_match
      perfect_item_match
    else
      nil
    end
  end
end
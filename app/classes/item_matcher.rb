class ItemMatcher
  def initialize(args)
    @items = args[:items]
    @criteria = args[:criteria]
  end
  def match
    perfect_item_match = @items.select(:name => @criteria[:name], :price => @criteria[:price], :description_text => @criteria[:description_text])
    if perfect_item_match
      perfect_item_match
    else
      nil
    end
  end
end
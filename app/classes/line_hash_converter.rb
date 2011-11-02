# Converts line hash to item
# If line hash matches an item, we return that item
# If no match, we make a new item
class LineHashConverter
  def initialize(args)
    @items = args[:items]
    @line_hash = args[:line_hash]
  end
  def convert_to_item
    perfect_item_match = @items.select{ |i| i.matches?(@line_hash) }.first
    return perfect_item_match unless perfect_item_match.nil?
    
    name_and_price_match = @items.select{ |i| i.name_and_price_match?(@line_hash) }.first
    return name_and_price_match unless name_and_price_match.nil?
    
    price_and_description_match = @items.select{ |i| i.price_and_description_match?(@line_hash) }.first
    return price_and_description_match unless price_and_description_match.nil?

    name_and_description_match = @items.select{ |i| i.name_and_description_match?(@line_hash) }.first
    return name_and_description_match unless name_and_description_match.nil?
    
    create_item
  end
  
  def create_item
    Item.create(@line_hash)
  end
end
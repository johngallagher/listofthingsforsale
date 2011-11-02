# Converts line hash to item
# If line hash matches an item, we return that item
# If no match, we make a new item
class LineHashConverter
  def initialize(args)
    @existing_items = args[:existing_items]
    @line = args[:line]
  end
  def convert_to_item
    
  end
end
# Converts line hashes to items
# As we go through the items, we remove the ones we've matched.
class LineHashesConverter
  def initialize(args)
    @existing_items = args[:existing_items]
    @line_hashes = args[:line_hashes]
    @converted_items = []
  end
  def convert_to_items
    @remaining_items = @existing_items
    @line_hashes.each do |line_hash|
      @converted_item = LineHashConverter.new(:line_hash => line_hash, :existing_items => @remaining_items).convert_to_item
      @converted_items << @converted_item
      @remaining_items.delete(@converted_item)
    end
    @converted_items
  end
end
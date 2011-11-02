class LineHashesConverter
  def initialize(args)
    @existing_items = args[:existing_items]
    @line_hashes = args[:line_hashes]
    @converted_items = []
  end
  def convert_to_items
    @remaining_items = @existing_items
    @line_hashes.each do |line_hash|
      @new_item = LineHashConverter.new(:line_hash => line_hash, :existing_items => @remaining_items).convert_to_item
      if @new_item
        @converted_items << @new_item
        @remoining_items = @remaining_items - @new_item unless !@remaining_items.include?(@new_item)
      end
    end
    @converted_items
  end
end
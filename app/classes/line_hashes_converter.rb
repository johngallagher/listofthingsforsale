# Converts line hashes to items
# As we go through the items, we remove the ones we've matched.
class LineHashesConverter
  def initialize(args)
    @existing_items = args[:existing_items]
    @line_hashes = args[:line_hashes]
    @converted_items = @line_hashes
    # @converted_line_hashes = []
  end
  def convert_to_items
    @remaining_items = @existing_items
    convert_exact_matches
    convert_partial_matches
    convert_new_items
    @converted_items
  end
  
  def convert_exact_matches
    @line_hashes.each do |this_line_hash|
      found_item = ItemFinder.new(:line_hash => this_line_hash, :existing_items => @remaining_items).find_exact_match
      if found_item
        found_item.update_attributes(this_line_hash)
        replace_item_hash_with_item(:item_hash => this_line_hash, :item => found_item)
        @remaining_items.delete(@converted_item)
      end
    end
  end
  
  def convert_partial_matches
    @line_hashes.each do |this_line_hash|
      found_item = ItemFinder.new(:line_hash => this_line_hash, :existing_items => @remaining_items).find_partial_match
      if found_item
        found_item.update_attributes(this_line_hash)
        replace_item_hash_with_item(:item_hash => this_line_hash, :item => found_item)
        @remaining_items.delete(@converted_item)
      end
    end
  end
  def convert_new_items
    @line_hashes.select{|l| l.class == Hash }.each do |this_line_hash|
      this_line_hash.delete(:cat1)
      new_item = Item.create(this_line_hash)
      new_item.save
      puts "I just created #{new_item.inspect}"
      replace_item_hash_with_item(:item_hash => this_line_hash, :item => new_item)
    end
  end
  # To replace item hash with item
  def replace_item_hash_with_item(args)
    @converted_items[@converted_items.index(args[:item_hash])] = args[:item] if @converted_items.index(args[:item_hash])
  end
end
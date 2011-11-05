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
    add_sort_indexes
    @line_hashes
  end
  
  def convert_exact_matches
    @line_hashes.each do |this_line_hash|
      found_item = ItemFinder.new(:line_hash => this_line_hash, :existing_items => @remaining_items).find_exact_match
      if found_item.present?
        category_names = this_line_hash.delete(:categories) unless this_line_hash[:categories].nil?
        update_categories(:category_names => category_names, :item => found_item)
        
        found_item.update_attributes(this_line_hash)
        
        replace_item_hash_with_item(:item_hash => this_line_hash, :item => found_item)
        @remaining_items.delete(@converted_item)
      end
    end
  end
  
  def convert_partial_matches
    @line_hashes.each do |this_line_hash|
      found_item = ItemFinder.new(:line_hash => this_line_hash, :existing_items => @remaining_items).find_partial_match
      if found_item.present?
        category_names = this_line_hash.delete(:categories) unless this_line_hash[:categories].nil?
        found_item.update_attributes(this_line_hash)
        replace_item_hash_with_item(:item_hash => this_line_hash, :item => found_item)
        
        update_categories(:category_names => category_names, :item => found_item)
        
        @remaining_items.delete(@converted_item)
      end
    end
  end
  def convert_new_items
    @line_hashes.select{|l| l.class == Hash }.each do |this_line_hash|
      categories_hash = this_line_hash.delete(:categories) unless this_line_hash[:categories].nil?
      new_item = Item.create(this_line_hash)
      new_item.save
      update_categories(:category_names => categories_hash, :item => new_item)
      
      replace_item_hash_with_item(:item_hash => this_line_hash, :item => new_item)
    end
  end
  def add_sort_indexes
    @line_hashes.each do |this_item|
      this_item.sort_order = @line_hashes.index(this_item)
      this_item.save
    end
  end
  # To replace item hash with item
  def replace_item_hash_with_item(args)
    @converted_items[@converted_items.index(args[:item_hash])] = args[:item] if @converted_items.index(args[:item_hash])
  end
  def update_categories(args)
    item            = args[:item]
    category_names  = args[:category_names]
    if category_names.nil? or item.nil? then return end
      
    item.categories.clear
    
    category_names.each do |category_name|
      item_category = Category.where(:name => category_name)
      if item_category.present?
        item.categories << item_category
      else
        item.categories.create(:name => category_name)
      end
      item.save
    end
  end
end
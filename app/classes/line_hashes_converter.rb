# Converts line hashes to items
# As we go through the items, we remove the ones we've matched.
class LineHashesConverter
  def initialize(args)
    @existing_items = args[:existing_items]
    @converted_items = args[:line_hashes]
  end

  def convert_to_items
    convert_exact_matches
    convert_partial_matches
    convert_new_items
    add_sort_indexes
    @converted_items
  end
  
  def convert_exact_matches
    line_hashes_to_items(:partial => false)
  end
  
  def convert_partial_matches
    line_hashes_to_items(:partial => true)
  end

  def line_hashes_to_items(args)
    @converted_items.each do |this_item|
      found_item = ItemFinder.new(:line_hash => this_item, :existing_items => @existing_items, :partial => args[:partial]).find_match
      if found_item.present?
        category_names = this_item.delete(:categories) unless this_item[:categories].nil?
        update_categories(:category_names => category_names, :item => found_item)
        
        found_item.update_attributes(this_item)
        
        replace_item_hash_with_item(:item_hash => this_item, :item => found_item)
      end
    end
  end

  def convert_new_items
    @converted_items.select{|l| l.class == Hash }.each do |this_item|
      categories_hash = this_item.delete(:categories) unless this_item[:categories].nil?

      new_item = Item.create(this_item)
      new_item.save
      
      update_categories(:category_names => categories_hash, :item => new_item)
      replace_item_hash_with_item(:item_hash => this_item, :item => new_item)
    end
  end

  def add_sort_indexes
    @converted_items.each do |this_item|
      this_item.sort_order = @converted_items.index(this_item)
      this_item.save
    end
  end

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
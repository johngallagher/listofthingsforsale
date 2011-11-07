require 'category_name_sanitizer'
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
    line_hashes_to_items(:existing => true, :partial => false)
  end
  
  def convert_partial_matches
    line_hashes_to_items(:existing => true, :partial => true)
  end

  def convert_new_items
    line_hashes_to_items
  end

  def line_hashes_to_items(args={})
    @converted_items.select{|l| l.class == Hash }.each do |this_line_hash|
      if args[:existing]
        item = ItemFinder.new(:line_hash => this_line_hash, :existing_items => @existing_items, :partial => args[:partial]).find_match
        replace_line_hash_with_item(:item => item, :line_hash => this_line_hash) unless item.nil?
      else
        replace_line_hash_with_item(:item => item, :line_hash => this_line_hash)
      end
    end
  end

  def replace_line_hash_with_item(args)
    this_line_hash = args[:line_hash]
    item = args[:item]
    category_names = this_line_hash.delete(:categories) unless this_line_hash[:categories].nil?

    if item.nil?
      item = Item.create(this_line_hash)
      item.save
    else
      item.update_attributes(this_line_hash)
    end

    update_categories(:category_names => category_names, :item => item)
    replace_item_hash_with_item(:item_hash => this_line_hash, :item => item)
  end
  

  def add_sort_indexes
    @converted_items.each do |this_line_hash|
      this_line_hash.sort_order = @converted_items.index(this_line_hash)
      this_line_hash.save
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
      category_css_name = CategoryNameSanitizer.new(category_name).sanitize.downcase
      Rails.logger.debug "Cat name is #{category_css_name} from #{category_name}"
      item_category = Category.where(:css_name => category_css_name)
      if item_category.present?
        item.categories << item_category.first
      else
        c = Category.create(:name => category_name.titleize, :css_name => category_css_name)
        c.save
        item.categories << c
      end
      item.save
    end
  end
end
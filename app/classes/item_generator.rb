# encoding: UTF-8
class ItemGenerator
  def initialize(args)
    @items        = args[:items]
    @description  = args[:description]
    @generated_items = []
    @line_hashes = []
  end
  def generate_items
    parse_lines
    convert_line_hashes
    remove_old_items
    @generated_items
  end
  def parse_lines
    @description.split("\n").each do |line|
      line_hash = LineParser.parse(line)
      @line_hashes << line_hash unless line_hash.nil?
    end
  end
  def convert_line_hashes
    @generated_items = LineHashesConverter.new(:line_hashes => @line_hashes, :existing_items => @items).convert_to_items
  end
  def remove_old_items
    if @items.present?
      @old_items = @items - @generated_items 
      @old_items.destroy_all
    end
  end
  def generate_items_old
    @generated_items = []
    # @item_index = 0
    @description.split("\n").each do |line|
      item_hash = item_hash_from_description(this_item_description)
      if !item_hash.nil?
        @item_index = @item_index + 1
        # Rails.logger.debug "Item hash is #{item_hash.inspect}"
        found_item = find_item_in_current_items(item_hash)
        if found_item.nil?
          found_item = Item.new
        end
        # Rails.logger.debug "Found item is #{found_item.inspect}"
      
        found_item.name = item_hash[:name]
        found_item.description_text = item_hash[:description_text]
        found_item.price = item_hash[:price]
        found_item.quantity = item_hash[:quantity]
        found_item.sort_order = @item_index
        found_item.save
        
        # Rails.logger.debug "Found item after is #{found_item.inspect}"
      
        @items << found_item
      end
    end
    return @items
  end
  
  def find_item_in_current_items(item_hash)
    @found_item = nil
    @current_items.each do |this_item|
      names_match = (this_item.name == item_hash[:name])
      descriptions_match = (this_item.description_text == item_hash[:description_text])
      prices_match = (this_item.price.to_f == item_hash[:price])
      @found_item = this_item if names_match || descriptions_match
    end
    return @found_item
  end
  
  def matches_from_description(description)
    Rails.logger.debug "About to match #{description}"
    # description.match(/([[:print:]]+) \$(\d+\.*\d*)([[:print:]][^\+#]*)?(\+(\d+))?( #([[:print:]][^#]*))?( #([[:print:]][^#]*))?( #([[:print:]][^#]*))?( #([[:print:]][^#]*))?( #([[:print:]][^#]*))?$/)
    # description.match(/(?<name>[[:print:]]+) \$(?<price>\d+\.*\d*)(?<descr> [[:print:]][^\+#]*)?(?<quantity>\+(\d+))?(?<cat1> #([[:print:]][^#]*))?( #(?<cat2>[[:print:]][^#]*))?( #(?<cat3>[[:print:]][^#]*))?( #(?<cat4>[[:print:]][^#]*))?( #(?<cat5>[[:print:]][^#]*))?$/)
    description.chomp.match(/(?<name>[[:print:]]+) \$(?<price>\d+\.*\d*)(?<description_text> [[:print:]][^\+#]*)?(?<quantity>\+(\d+))?(?<cat1> #([[:print:]][^#]*))?$/)
    # description.chomp.match(/(?<name>[[:print:]]+) \$(?<price>\d+\.*\d*)(?<description_text> [[:print:]][^\+#]*)?(?<quantity>\+(\d+))?(?<cat1> #([[:print:]][^#]*))?( #(?<cat2>[[:print:]][^#]*))?( #(?<cat3>[[:print:]][^#]*))?( #(?<cat4>[[:print:]][^#]*))?( #(?<cat5>[[:print:]][^#]*))$/)
    # description.match(/([[:print:]]+) \$(\d+\.*\d*)( [[:print:]][^\+]*)?(\+(\d+))?/)
  end
  
  def item_hash_from_description(description)
    this_item_matches = matches_from_description(description)
    Rails.logger.debug "This item matches is #{this_item_matches.inspect}"
    if this_item_matches and this_item_matches.length >= 4
      return item_hash_from_matches(this_item_matches)
    else
      return nil
    end
  end

  def item_hash_from_matches(matches)
    item = {}
    # t.string   "name"
    # t.text     "description_text"
    # t.decimal  "price"

    item[:name] = matches[:name]
    item[:description_text] = matches[:description_text]
    item[:price] = matches[:price].to_f
    if matches[:price]
      if matches[:price].to_i > 1
        item[:quantity] = 1       # remove this when we implement quantities
      else
        item[:quantity] = matches[:price].to_i
      end
    else 
      item[:quantity] = 1
    end
    item[:cat1] = matches[:cat1]
    # item[:name] = matches[1]
    # item[:description_text] = matches[3]
    # item[:price] = matches[2].to_f
    # if matches[2]
    #   if matches[2].to_i > 1
    #     item[:quantity] = 1       # remove this when we implement quantities
    #   else
    #     item[:quantity] = matches[2].to_i
    #   end
    # else 
    #   item[:quantity] = 1
    # end
    Rails.logger.debug "Here's the item - #{item.inspect}"
    return item
  end
end
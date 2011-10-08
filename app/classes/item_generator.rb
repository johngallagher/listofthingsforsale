# encoding: UTF-8
class ItemGenerator
  attr_accessor :new_description
  
  def initialize(args)
    @new_description = args[:new_description]
    @old_description = args[:old_description]
    @current_items = args[:items]
  end
  
  def generate_items
    @items = []
    @new_description.split("\n").each do |this_item_description|
      item_hash = item_hash_from_description(this_item_description)
      if !item_hash.nil?
        Rails.logger.debug "Item hash is #{item_hash.inspect}"
        found_item = find_item_in_current_items(item_hash)
        if found_item.nil?
          found_item = Item.new
        end
        Rails.logger.debug "Found item is #{found_item.inspect}"
      
        found_item.name = item_hash[:name]
        found_item.description_text = item_hash[:description_text]
        found_item.price = item_hash[:price]
        found_item.quantity = item_hash[:quantity]
        found_item.save
        
        Rails.logger.debug "Found item after is #{found_item.inspect}"
      
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
    description.match(/([[:print:]]+) £(\d+\.*\d*) ([[:print:]][^\+]+)(\+(\d+))?/)
    # description.match(/([[:print:]]+) £(\d+\.*\d*) ([[:print:]]+)/)
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

    item[:name] = matches[1]
    item[:description_text] = matches[3]
    item[:price] = matches[2].to_f
    if matches[5]
      # if matches[5].to_i > 1
      #   item[:quantity] = 1       # remove this when we implement quantities
      # else
        item[:quantity] = matches[5].to_i
      # end
    else 
      item[:quantity] = 1
    end
    return item
  end
end
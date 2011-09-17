# encoding: UTF-8
class ItemGenerator
  attr_accessor :description_of_items
  
  def initialize(description_of_items)
    @description_of_items = description_of_items
  end
  
  def generate_items
    @items = []
    @description_of_items.split("\n").each do |this_item_description|
      this_item = item_from_description(this_item_description)
      if this_item then @items << this_item end
    end
    @items
  end
  
  def item_from_description(description)
    @reg = /£(\d+\.*\d*) ([[:print:]]+) @([[:print:]]+)/
    this_item_matches = description.match(@reg)
    if this_item_matches and this_item_matches.length == 4
      return item_from_matches(this_item_matches)
    else
      return nil
    end
  end
  
  def item_from_matches(matches)
    item = Item.new
    # t.string   "name"
    # t.text     "description_text"
    # t.decimal  "price"

    item.name = matches[2]
    item.description_text = matches[3]
    item.price = matches[1].to_f
    item.save
    return item
  end
end
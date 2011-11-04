require 'text'
class ItemFinder
  def initialize(args)
    @existing_items = args[:existing_items]
    @line_hash = args[:line_hash]
  end
  def find_exact_match
    perfect_item_match = @existing_items.select{ |i| i.matches?(@line_hash) }.first
    return perfect_item_match unless perfect_item_match.nil?
  end
  def find_partial_match
    name_and_price_matches = @existing_items.select{ |i| i.name_and_price_match?(@line_hash) }
    name_and_price_match = name_and_price_matches.sort { |a,b| Text::Levenshtein.distance(a.description_text, @line_hash[:description_text]) <=> Text::Levenshtein.distance(b.description_text, @line_hash[:description_text])}.first
    return name_and_price_match unless name_and_price_match.nil?
    
    name_and_description_match = @existing_items.select{ |i| i.name_and_description_match?(@line_hash) }.first
    return name_and_description_match unless name_and_description_match.nil?

    price_and_description_match = @existing_items.select{ |i| i.price_and_description_match?(@line_hash) }.first
    return price_and_description_match unless price_and_description_match.nil?
  end
end
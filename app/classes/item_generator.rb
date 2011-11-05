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
      unless line_hash.nil?
        line_hash.delete(:categories)
        @line_hashes << line_hash
      end
    end
  end
  def convert_line_hashes
    @generated_items = LineHashesConverter.new(:line_hashes => @line_hashes, :existing_items => @items).convert_to_items
    Rails.logger.debug "----Generated items #{@generated_items.inspect}\n------Line Hashes #{@line_hashes.inspect}\n------Old items #{@items.inspect}"
  end
  def remove_old_items
    if @items.present?
      @old_items = @items - @generated_items 
      @old_items.each do |item|
        item.delete
      end
    end
  end
end
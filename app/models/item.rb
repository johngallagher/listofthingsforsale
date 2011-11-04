class Item < ActiveRecord::Base
  has_attached_file :photo_1, :styles => { :medium => "800x800>", :thumb => "180x135>" }, :storage => :s3, :s3_credentials => "#{::Rails.root.to_s}/config/s3.yml", :path => "/:style/:id/:filename"
  
  belongs_to :shop
  has_many :photos
  has_many :line_items
  
  def matches?(line_hash)
    name == line_hash[:name] and price == line_hash[:price] and description_text == line_hash[:description_text]
  end
  def name_and_price_match?(line_hash)
    name == line_hash[:name] and price == line_hash[:price]
  end
  def price_and_description_match?(line_hash)
    description_text == line_hash[:description_text] and price == line_hash[:price]
  end
  def name_and_description_match?(line_hash)
    description_text == line_hash[:description_text] and name == line_hash[:name]
  end
  def equal_to_item?(item)
    name == item.name and price == item.price and description_text == item.description_text and quantity == item.quantity
  end
end

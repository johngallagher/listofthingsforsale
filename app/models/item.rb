class Item < ActiveRecord::Base
  has_attached_file :photo_1, :styles => { :medium => "800x800>", :thumb => "180x135>" }, :storage => :s3, :s3_credentials => "#{::Rails.root.to_s}/config/s3.yml", :path => "/:style/:id/:filename"
  
  belongs_to :shop
  has_many :photos
  has_many :line_items
  
  def matches?(criteria)
    name == criteria[:name] and price == criteria[:price] and description_text == criteria[:description_text]
  end
  def name_and_price_match?(criteria)
    name == criteria[:name] and price == criteria[:price]
  end
  def price_and_description_match?(criteria)
    description_text == criteria[:description_text] and price == criteria[:price]
  end
  def name_and_description_match?(criteria)
    description_text == criteria[:description_text] and name == criteria[:name]
  end
end

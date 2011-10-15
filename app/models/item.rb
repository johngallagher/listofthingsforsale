class Item < ActiveRecord::Base
  has_attached_file :photo_1, :styles => { :medium => "800x800>", :thumb => "180x135>" }, :storage => :s3, :s3_credentials => "#{::Rails.root.to_s}/config/s3.yml", :path => "/:style/:id/:filename"
  
  belongs_to :shop
  has_many :photos
  has_many :line_items
end

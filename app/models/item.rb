class Item < ActiveRecord::Base
  has_attached_file :photo_1, :styles => { :medium => "800x800>", :thumb => "50x50>" }, :storage => :s3, :s3_credentials => "#{RAILS_ROOT}/config/s3.yml", :path => "/:style/:id/:filename"
  
  belongs_to :shop
  has_many :photos
  has_many :line_items
end

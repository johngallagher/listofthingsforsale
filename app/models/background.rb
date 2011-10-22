class Background < ActiveRecord::Base
  has_attached_file :background_image, :styles => { :profile => "150x75#" }, :storage => :s3, :s3_credentials => "#{::Rails.root.to_s}/config/s3.yml", :path => "/:style/:id/:filename"
  has_many :shops, :class_name => "shop", :foreign_key => "background_id"
end

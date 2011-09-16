class Item < ActiveRecord::Base
  belongs_to :shop
  has_many :photos
end

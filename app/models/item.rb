class Item < ActiveRecord::Base
  belongs_to :shop
  has_many :photos
  has_many :line_items
end

class Order < ActiveRecord::Base
  belongs_to :shop
  has_many :line_items
end

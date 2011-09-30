class LineItem < ActiveRecord::Base
  belongs_to :item
  belongs_to :order
end

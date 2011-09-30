class LineItems < ActiveRecord::Base
  belongs_to :item
  belongs_to :order
end

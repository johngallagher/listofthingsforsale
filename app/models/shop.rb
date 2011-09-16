require 'ShopStatus'
class Shop < ActiveRecord::Base
   attr_accessor :description_for_shop
   has_many :items
   belongs_to :user
   
   after_initialize :init

   def init
     self.status  ||= ShopStatus::CREATED
   end
end

class Shop < ActiveRecord::Base
   attr_accessor :description_for_shop
   has_many :items
   belongs_to :user
   has_many :orders
   
   after_initialize :init

   def init
     self.status  ||= ShopStatus::CREATED
     self.payment_type ||= Payments::Paypal
   end
end

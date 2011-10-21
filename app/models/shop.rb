class Shop < ActiveRecord::Base
  has_friendly_id :url, :use_slug => true

  attr_accessor :description_for_shop, :publishing_errors
  has_many :items
  belongs_to :user
  has_many :orders
  

  after_initialize :init

  def init
    self.status  ||= ShopStatus::Offline
    self.payment_type ||= Payments::Paypal
    self.publishing_errors ||= []
  end
end

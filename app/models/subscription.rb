class Subscription < ActiveRecord::Base
  belongs_to :plan
  belongs_to :user
  validates_presence_of :plan_id
  validates_presence_of :user_id
  # validates_presence_of :email
  
  attr_accessor :paypal_payment_token
  
  def save_with_payment
    if valid?
      save_with_paypal_payment
    end
  end
  
  def paypal
    PaypalPayment.new(self)
  end
  
  def save_with_paypal_payment
    response = paypal.make_recurring
    self.paypal_recurring_profile_token = response.profile_id
    save!
  end

  def payment_provided?
    paypal_payment_token.present?
  end
end

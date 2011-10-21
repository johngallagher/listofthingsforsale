class User < ActiveRecord::Base
  has_many :authentications
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :confirmable, 
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me
  
  has_one :shop
  has_one :subscription

  accepts_nested_attributes_for :subscription, :update_only => true
  
  # after_initialize :init
  # 
  # def init
  #   if self.subscription.nil?
  #     no_plan = Subscription.where(:name => "None").first
  #     if no_plan
  #       self.plan = no_plan
  #     end
  #   end
  # end

  def subscription_plan_name
    if subscription and subscription.plan
      subscription.plan.name
    else
      "Personal"
    end
  end
  
  def verified?
    self.confirmed_at.present?
  end
end

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
  # after_initialize :init
  # 
  # def init
  #   if self.plan.nil?
  #     no_plan = Plan.where(:name => "None").first
  #     if no_plan
  #       self.plan = no_plan
  #     end
  #   end
  # end

  def plan_name
    if plan
      plan.name
    else
      ""
    end
  end
end

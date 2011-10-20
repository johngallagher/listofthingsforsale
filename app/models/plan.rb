class Plan < ActiveRecord::Base
  has_many :subscriptions
  
  def self.business_plan
    Plan.where("price > 0").first
  end
end

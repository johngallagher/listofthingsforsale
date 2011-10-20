class Plan < ActiveRecord::Base
  has_many :subscriptions
  
  def self.business_plan
    business_plan = Plan.where("price > 0").first
    return business_plan unless business_plan.nil?
    raise "No business plan found!"
  end
end

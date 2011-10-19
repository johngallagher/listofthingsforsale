class Subscription < ActiveRecord::Base
  has_many :users
end

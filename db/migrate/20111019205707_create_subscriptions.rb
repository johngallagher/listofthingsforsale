class CreateSubscriptions < ActiveRecord::Migration
  def self.up
    create_table :subscriptions do |t|
      t.integer :plan_id
      t.string :email
      t.string :paypal_customer_token
      t.string :paypal_recurring_profile_token
      t.integer :user_id

      t.timestamps
    end
  end

  def self.down
    drop_table :subscriptions
  end
end

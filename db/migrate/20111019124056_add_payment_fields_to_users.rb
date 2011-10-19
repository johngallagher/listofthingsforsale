class AddPaymentFieldsToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :plan_id, :integer
    add_column :users, :plan_paypal_customer_token, :string
    add_column :users, :plan_paypal_recurring_profile_token, :string
  end

  def self.down
    remove_column :users, :plan_paypal_recurring_profile_token
    remove_column :users, :plan_paypal_customer_token
    remove_column :users, :plan_id
  end
end

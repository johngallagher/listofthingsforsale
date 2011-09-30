class CreateOrders < ActiveRecord::Migration
  def self.up
    create_table :orders do |t|
      t.integer :shop_id
      t.datetime :ordered_on
      t.string :buyer_paypal_email

      t.timestamps
    end
  end

  def self.down
    drop_table :orders
  end
end

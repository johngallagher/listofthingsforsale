class CreateEmailOrders < ActiveRecord::Migration
  def self.up
    create_table :email_orders do |t|

      t.timestamps
    end
  end

  def self.down
    drop_table :email_orders
  end
end

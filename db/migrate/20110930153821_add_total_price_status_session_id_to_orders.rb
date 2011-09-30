class AddTotalPriceStatusSessionIdToOrders < ActiveRecord::Migration
  def self.up
    add_column :orders, :total_price, :decimal
    add_column :orders, :status, :string
    add_column :orders, :session_id, :string
  end

  def self.down
    remove_column :orders, :session_id
    remove_column :orders, :status
    remove_column :orders, :total_price
  end
end

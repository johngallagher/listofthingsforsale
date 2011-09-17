class AddPaymentTypeToShop < ActiveRecord::Migration
  def self.up
    add_column :shops, :payment_type, :string
  end

  def self.down
    remove_column :shops, :payment_type
  end
end

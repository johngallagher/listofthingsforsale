class AddDeliveryMethodToShop < ActiveRecord::Migration
  def self.up
    add_column :shops, :delivery_method, :text
  end

  def self.down
    remove_column :shops, :delivery_method
  end
end

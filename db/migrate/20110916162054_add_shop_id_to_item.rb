class AddShopIdToItem < ActiveRecord::Migration
  def self.up
    add_column :items, :shop_id, :integer
  end

  def self.down
    remove_column :items, :shop_id
  end
end

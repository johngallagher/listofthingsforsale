class AddPostagePriceToShopPrices < ActiveRecord::Migration
  def self.up
    add_column :shops, :postage_price, :decimal
  end

  def self.down
    remove_column :shops, :postage_price
  end
end

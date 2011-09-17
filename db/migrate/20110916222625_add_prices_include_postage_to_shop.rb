class AddPricesIncludePostageToShop < ActiveRecord::Migration
  def self.up
    add_column :shops, :prices_include_postage, :boolean
  end

  def self.down
    remove_column :shops, :prices_include_postage
  end
end

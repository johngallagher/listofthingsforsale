class AddCurrencyToShops < ActiveRecord::Migration
  def self.up
    add_column :shops, :currency, :string
  end

  def self.down
    remove_column :shops, :currency
  end
end

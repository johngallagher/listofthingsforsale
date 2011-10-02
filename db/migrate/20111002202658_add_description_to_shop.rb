class AddDescriptionToShop < ActiveRecord::Migration
  def self.up
    add_column :shops, :description, :text
  end

  def self.down
    remove_column :shops, :description
  end
end

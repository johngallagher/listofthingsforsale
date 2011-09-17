class AddPostageTypeToShop < ActiveRecord::Migration
  def self.up
    add_column :shops, :postage_type, :string
  end

  def self.down
    remove_column :shops, :postage_type
  end
end

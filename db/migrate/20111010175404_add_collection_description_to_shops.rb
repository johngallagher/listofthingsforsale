class AddCollectionDescriptionToShops < ActiveRecord::Migration
  def self.up
    add_column :shops, :collection_description, :text
  end

  def self.down
    remove_column :shops, :collection_description
  end
end

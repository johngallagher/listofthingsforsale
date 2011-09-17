class AddItemIdToPhotos < ActiveRecord::Migration
  def self.up
    add_column :photos, :item_id, :integer
  end

  def self.down
    remove_column :photos, :item_id
  end
end

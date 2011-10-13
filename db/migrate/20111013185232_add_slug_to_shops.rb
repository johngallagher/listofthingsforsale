class AddSlugToShops < ActiveRecord::Migration
  def self.up
    add_column :shops, :cached_slug, :string
    add_index :shops, :cached_slug, :unique => true
  end

  def self.down
    remove_column :shops, :cached_slug
  end
end

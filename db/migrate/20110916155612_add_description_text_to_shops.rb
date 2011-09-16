class AddDescriptionTextToShops < ActiveRecord::Migration
  def self.up
    add_column :shops, :description_text, :text
  end

  def self.down
    remove_column :shops, :description_text
  end
end

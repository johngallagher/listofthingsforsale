class AddBackgroundToShops < ActiveRecord::Migration
  def self.up
    add_column :shops, :background_id, :integer
  end

  def self.down
    remove_column :shops, :background_id
  end
end

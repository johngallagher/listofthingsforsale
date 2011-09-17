class AddStatusToShops < ActiveRecord::Migration
  def self.up
    add_column :shops, :status, :integer
  end

  def self.down
    remove_column :shops, :status
  end
end

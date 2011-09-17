class AddUserIdToShops < ActiveRecord::Migration
  def self.up
    add_column :shops, :user_id, :integer
  end

  def self.down
    remove_column :shops, :user_id
  end
end

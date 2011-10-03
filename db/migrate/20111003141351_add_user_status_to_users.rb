class AddUserStatusToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :user_status, :string
  end

  def self.down
    remove_column :users, :user_status
  end
end

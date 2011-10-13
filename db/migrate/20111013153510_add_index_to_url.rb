class AddIndexToUrl < ActiveRecord::Migration
  def self.up
    add_index :shops, :url,                :unique => true
  end

  def self.down
    remove_index :shops, :url
  end
end

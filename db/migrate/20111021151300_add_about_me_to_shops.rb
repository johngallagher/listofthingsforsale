class AddAboutMeToShops < ActiveRecord::Migration
  def self.up
    add_column :shops, :about_me, :text
  end

  def self.down
    remove_column :shops, :about_me
  end
end

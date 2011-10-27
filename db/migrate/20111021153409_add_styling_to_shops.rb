class AddStylingToShops < ActiveRecord::Migration
  def self.up
    add_column :shops, :style, :string
  end

  def self.down
    remove_column :shops, :style
  end
end

class AddNameToLineItem < ActiveRecord::Migration
  def self.up
    add_column :line_items, :name, :string
  end

  def self.down
    remove_column :line_items, :name
  end
end

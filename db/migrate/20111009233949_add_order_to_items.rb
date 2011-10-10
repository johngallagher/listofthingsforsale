class AddOrderToItems < ActiveRecord::Migration
  def self.up
    add_column :items, :sort_order, :integer
  end

  def self.down
    remove_column :items, :sort_order
  end
end

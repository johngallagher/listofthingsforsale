class CreateItemsCategories < ActiveRecord::Migration
  def self.up
    create_table :categories_items, :id => false do |t|
      t.integer :item_id
      t.integer :category_id
    end
  end

  def self.down
    drop_table :categories_items
  end
end

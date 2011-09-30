class CreateLineItems < ActiveRecord::Migration
  def self.up
    create_table :line_items do |t|
      t.decimal :unit_price
      t.integer :quantity
      t.integer :order_id
      t.integer :item_id

      t.timestamps
    end
  end

  def self.down
    drop_table :line_items
  end
end

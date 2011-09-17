class RemoveDescriptions < ActiveRecord::Migration
  def self.up
    drop_table :descriptions
  end

  def self.down
    create_table :descriptions do |t|
      t.text :items_description

      t.timestamps
    end
  end
end

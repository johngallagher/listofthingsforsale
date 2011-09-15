class CreateDescriptions < ActiveRecord::Migration
  def self.up
    create_table :descriptions do |t|
      t.text :items_description

      t.timestamps
    end
  end

  def self.down
    drop_table :descriptions
  end
end

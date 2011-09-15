class CreatePhotos < ActiveRecord::Migration
  def self.up
    create_table :photos do |t|
      t.string :thumb_url
      t.string :small_url
      t.string :large_url
      t.string :caption

      t.timestamps
    end
  end

  def self.down
    drop_table :photos
  end
end

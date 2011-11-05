class AddCssNameToCategories < ActiveRecord::Migration
  def self.up
    add_column :categories, :css_name, :string
  end

  def self.down
    remove_column :categories, :css_name
  end
end

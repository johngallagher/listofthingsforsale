class AddProductsTextToList < ActiveRecord::Migration
  def change
    add_column :lists, :products_text, :text
  end
end

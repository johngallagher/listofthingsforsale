class AddPaymentOtherTextToShop < ActiveRecord::Migration
  def self.up
    add_column :shops, :payment_other_text, :text
  end

  def self.down
    remove_column :shops, :payment_other_text
  end
end

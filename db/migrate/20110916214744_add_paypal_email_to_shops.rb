class AddPaypalEmailToShops < ActiveRecord::Migration
  def self.up
    add_column :shops, :paypal_email, :string
  end

  def self.down
    remove_column :shops, :paypal_email
  end
end

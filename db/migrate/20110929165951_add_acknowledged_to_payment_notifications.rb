class AddAcknowledgedToPaymentNotifications < ActiveRecord::Migration
  def self.up
    add_column :payment_notifications, :acknowledged, :boolean
  end

  def self.down
    remove_column :payment_notifications, :acknowledged
  end
end

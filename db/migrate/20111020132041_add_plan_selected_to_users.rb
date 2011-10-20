class AddPlanSelectedToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :plan_selected, :boolean
  end

  def self.down
    remove_column :users, :plan_selected
  end
end

class AddIsTravelPlannerToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :is_travel_planner, :boolean
  end

  def self.down
    remove_column :users, :is_travel_planner
  end
end

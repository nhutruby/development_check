class AddSelectedPlan < ActiveRecord::Migration
  def self.up
    add_column :organizations, :selected_plan, :string, :default => 'free_plan'
    Organization.reset_column_information
    Organization.update_all(:selected_plan => 'free_plan')    
  end

  def self.down
    remove_column :organizations, :selected_plan
  end
end

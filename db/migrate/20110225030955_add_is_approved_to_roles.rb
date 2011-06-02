class AddIsApprovedToRoles < ActiveRecord::Migration
  def self.up
    add_column :roles, :is_approved, :boolean
  end

  def self.down
    remove_column :roles, :is_approved
  end
end

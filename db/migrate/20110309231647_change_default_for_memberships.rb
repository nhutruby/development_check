class ChangeDefaultForMemberships < ActiveRecord::Migration
  def self.up
    change_column :memberships, :is_organization_approved, :boolean, :default => true, :null => false
    remove_column :memberships, :is_user_approved
  end

  def self.down
    add_column :memberships, :is_user_approved, :boolean,  :default => true, :null => false
    change_column :memberships, :is_organization_approved, :boolean, :default => false, :null => false
  end
end

class ChangeOwnerFromRolesToOrganizations < ActiveRecord::Migration
  def self.up
    remove_column :roles, :is_owner
    add_column :organizations, :owner_id, :integer
  end

  def self.down
    add_column :roles, :is_owner, :boolean
    remove_column :organizations, :owner_id
  end
end

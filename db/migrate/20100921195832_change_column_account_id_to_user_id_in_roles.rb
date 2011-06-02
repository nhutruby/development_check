class ChangeColumnAccountIdToUserIdInRoles < ActiveRecord::Migration
  def self.up
    rename_column :roles, :account_id, :organization_id
  end

  def self.down
    rename_column :roles, :organization_id, :account_id
  end
end

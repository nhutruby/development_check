class AddInviterAndOrganizationIdToUser < ActiveRecord::Migration
  def self.up
      add_column :users, :inviter,  :string
      add_column :users, :temp_org_id,  :integer
  end

  def self.down
      remove_column :users, :inviter
      remove_column :users, :temp_org_id
  end
end

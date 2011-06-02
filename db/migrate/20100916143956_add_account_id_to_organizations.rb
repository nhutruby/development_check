class AddAccountIdToOrganizations < ActiveRecord::Migration
  def self.up
    add_column :organizations, :account_id, :boolean
  end

  def self.down
    remove_column :organizations, :account_id
  end
end

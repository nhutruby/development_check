class ChangeAccountIdInOrganizations < ActiveRecord::Migration
  def self.up
    remove_column :organizations, :account_id
    add_column :organizations, :account_id, :integer
  end

  def self.down
  end
end

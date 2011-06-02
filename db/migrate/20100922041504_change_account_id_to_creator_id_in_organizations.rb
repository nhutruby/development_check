class ChangeAccountIdToCreatorIdInOrganizations < ActiveRecord::Migration
  def self.up
    rename_column :organizations, :account_id, :creator_id
  end

  def self.down
  end
end

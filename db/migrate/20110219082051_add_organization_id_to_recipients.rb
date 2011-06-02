class AddOrganizationIdToRecipients < ActiveRecord::Migration
  def self.up
    add_column :recipients, :organization_id, :integer
  end

  def self.down
    remove_column :recipients, :organization_id
  end
end

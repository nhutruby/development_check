class AddAccountTypeIdToOrganizations < ActiveRecord::Migration
  def self.up
    add_column  :organizations, :account_id, :integer
    remove_column  :organizations, :account_type
  end

  def self.down
    remove_column  :organizations, :account_id
    add_column  :organizations, :account_type, :string
  end
end

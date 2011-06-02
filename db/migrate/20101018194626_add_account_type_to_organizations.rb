class AddAccountTypeToOrganizations < ActiveRecord::Migration
  def self.up
    add_column  :organizations, :account_type, :string
  end

  def self.down
    remove_column  :organizations, :account_type  end
end

class AddMasterTypeToOrganizations < ActiveRecord::Migration
  def self.up
    add_column :organizations, :master_type, :string
  end

  def self.down
    remove_column :organizations, :master_type
  end
end

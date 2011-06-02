class RemoveMasterTypeFromOrganizations < ActiveRecord::Migration
  def self.up
    remove_index(:organizations, :master_type)
    remove_column :organizations, :master_type
  end

  def self.down
    add_column :organizations, :master_type, :string
    add_index(:organizations, :master_type)
  end
end

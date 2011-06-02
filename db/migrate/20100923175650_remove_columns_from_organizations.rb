class RemoveColumnsFromOrganizations < ActiveRecord::Migration
  def self.up
    remove_column :organizations, :is_provider_varified
    remove_column :organizations, :is_provider
    remove_column :organizations, :is_supplier
    remove_column :organizations, :is_consumer
  end

  def self.down
  end
end
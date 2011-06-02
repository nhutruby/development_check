class AddIsProviderVarifiedToOrganizations < ActiveRecord::Migration
  def self.up
    add_column :organizations, :is_provider_varified, :boolean
  end

  def self.down
    remove_column :organizations, :is_provider_varified
  end
end

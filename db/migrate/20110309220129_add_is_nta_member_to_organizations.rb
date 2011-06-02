class AddIsNtaMemberToOrganizations < ActiveRecord::Migration
  def self.up
    add_column :organizations, :is_nta_member, :boolean
  end

  def self.down
    remove_column :organizations, :is_nta_member
  end
end

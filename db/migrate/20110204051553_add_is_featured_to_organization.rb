class AddIsFeaturedToOrganization < ActiveRecord::Migration
  def self.up
    add_column :organizations, :is_featured, :boolean, :default => false
  end

  def self.down
    remove_column :organizations, :is_featured
  end
end


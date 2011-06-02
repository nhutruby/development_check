class AddIsDeletedFields < ActiveRecord::Migration
  def self.up
    add_column :users, :is_deleted, :boolean, :default => false, :null => false
    add_column :organizations, :is_deleted, :boolean, :default => false, :null => false
    add_column :locations, :is_deleted, :boolean, :default => false, :null => false
    add_column :inventory_items, :is_deleted, :boolean, :default => false, :null => false
  end

  def self.down
    remove_column :users, :is_deleted
    remove_column :organizations, :is_deleted
    remove_column :locations, :is_deleted
    remove_column :inventory_items, :is_deleted
  end
end

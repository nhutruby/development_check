class RenameColumnInUsers < ActiveRecord::Migration
  def self.up
    rename_column :users, :is_approved, :is_active
  end

  def self.down
    rename_column :users, :is_active, :is_approved
  end
end

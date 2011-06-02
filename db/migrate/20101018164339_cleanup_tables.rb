class CleanupTables < ActiveRecord::Migration
  def self.up
    drop_table :accounts
    drop_table :parties
    drop_table :roles
  end

  def self.down
  end
end

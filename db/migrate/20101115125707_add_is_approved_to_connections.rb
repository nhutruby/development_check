class AddIsApprovedToConnections < ActiveRecord::Migration
  def self.up
    add_column :connections, :is_approved, :boolean
  end

  def self.down
    remove_column :connections, :is_approved
  end
end

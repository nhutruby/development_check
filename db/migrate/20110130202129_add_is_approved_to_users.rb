class AddIsApprovedToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :is_approved, :boolean
  end

  def self.down
    remove_column :users, :is_approved
  end
end

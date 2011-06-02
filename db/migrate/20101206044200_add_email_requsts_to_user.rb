class AddEmailRequstsToUser < ActiveRecord::Migration
  def self.up
    add_column :users, :email_requests, :boolean
  end

  def self.down
    remove_column :users, :email_requests
  end
end

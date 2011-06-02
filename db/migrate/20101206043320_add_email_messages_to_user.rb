class AddEmailMessagesToUser < ActiveRecord::Migration
  def self.up
    add_column :users, :email_messages, :boolean
  end

  def self.down
    remove_column :users, :email_messages
  end
end

class AddInvitationMessageToUser < ActiveRecord::Migration
  def self.up
    add_column :users, :message, :text
  end

  def self.down
    remove_column :users, :message
  end
end

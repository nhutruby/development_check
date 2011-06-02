class AddInviterNameToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :inviter_name, :string
  end

  def self.down
    remove_column :users, :inviter_name
  end
end

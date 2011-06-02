class AddRoleIdToRecipient < ActiveRecord::Migration
  def self.up
    add_column :recipients, :role_id, :integer
  end

  def self.down
    remove_column :recipients, :role_id
  end
end

class ChangeItsAdminInUsersToBoolean < ActiveRecord::Migration
  def self.up
    change_column :users, :its_admin, :boolean, :null => true
  end

  def self.down
    change_column :users, :its_admin, :boolean, :null => false
  end
end

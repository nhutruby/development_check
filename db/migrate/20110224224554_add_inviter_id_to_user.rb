class AddInviterIdToUser < ActiveRecord::Migration
  def self.up
    add_column :users, :invited_by_id, :integer
  end

  def self.down
    remove_column :users, :invited_by_id
  end
end

class AddIsCoworkerToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :is_coworker, :boolean
  end

  def self.down
    remove_column :users, :is_coworker
  end
end

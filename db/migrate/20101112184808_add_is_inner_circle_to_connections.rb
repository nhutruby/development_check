class AddIsInnerCircleToConnections < ActiveRecord::Migration
  def self.up
    add_column :connections, :is_inner_circle, :boolean
  end

  def self.down
    remove_column :connections, :is_inner_circle
  end
end

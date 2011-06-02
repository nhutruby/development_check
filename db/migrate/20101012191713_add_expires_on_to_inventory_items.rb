class AddExpiresOnToInventoryItems < ActiveRecord::Migration
  def self.up
    add_column :inventory_items, :expires_on, :date
  end

  def self.down
    remove_column :inventory_items, :expires_on
  end
end

class AddColumnsToInventoryItems < ActiveRecord::Migration
  def self.up
    add_column :inventory_items, :price_retail, :decimal, :precision => 8, :scale => 2 
    add_column :inventory_items, :price_net, :decimal, :precision => 8, :scale => 2 
  end

  def self.down
    remove_column :inventory_items, :price_net
    remove_column :inventory_items, :price_retail
  end
end

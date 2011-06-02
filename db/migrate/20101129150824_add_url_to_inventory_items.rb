class AddUrlToInventoryItems < ActiveRecord::Migration
  def self.up
    add_column :inventory_items, :url, :string
    remove_column :inventory_items, :price_retail
    remove_column :inventory_items, :price_net
  end

  def self.down   
    add_column :inventory_items, :price_retail, :decimal, :precision => 8, :scale => 2
    add_column :inventory_items, :price_net, :decimal, :precision => 8, :scale => 2
    remove_column :inventory_items, :url
  end
end

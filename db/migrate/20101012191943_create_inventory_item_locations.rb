class CreateInventoryItemLocations < ActiveRecord::Migration
  def self.up
    create_table :inventory_item_locations do |t|
      t.integer :location_id
      t.integer :inventory_item_id
      t.timestamps
    end
  end

  def self.down
    drop_table :inventory_item_locations
  end
end

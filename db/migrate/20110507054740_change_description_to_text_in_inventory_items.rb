class ChangeDescriptionToTextInInventoryItems < ActiveRecord::Migration
  def self.up
    change_column :inventory_items, :description, :text
  end

  def self.down
    change_column :inventory_items, :description, :string
  end
end

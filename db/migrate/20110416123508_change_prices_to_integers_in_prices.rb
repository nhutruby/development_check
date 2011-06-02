class ChangePricesToIntegersInPrices < ActiveRecord::Migration
  def self.up
    change_column :prices, :price_low, :integer, :default => 0, :null => false
    change_column :prices, :price_high, :integer, :default => 0, :null => false
    change_column :prices, :retail_low, :integer, :default => 0, :null => false
    change_column :prices, :retail_high, :integer, :default => 0, :null => false
    rename_column :prices, :price_low, :price_low_cents
    rename_column :prices, :price_high, :price_high_cents
    rename_column :prices, :retail_low, :retail_low_cents
    rename_column :prices, :retail_high, :retail_high_cents
  end

  def self.down
    rename_column :prices, :price_low_cents, :price_low
    rename_column :prices, :price_high_cents, :price_high
    rename_column :prices, :retail_low_cents, :retail_low
    rename_column :prices, :retail_high_cents, :retail_high
    change_column :prices, :price_low, :decimal, :precision => 8, :scale => 2
    change_column :prices, :price_high, :decimal, :precision => 8, :scale => 2
    change_column :prices, :retail_low, :decimal, :precision => 8, :scale => 2
    change_column :prices, :retail_high, :decimal, :precision => 8, :scale => 2
  end
end

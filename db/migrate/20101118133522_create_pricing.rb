class CreatePricing < ActiveRecord::Migration
  def self.up
    create_table :prices do |t|
      t.decimal :retail_low, :precision => 8, :scale => 2
      t.decimal :retail_high, :precision => 8, :scale => 2
      t.decimal :price_low, :precision => 8, :scale => 2
      t.decimal :price_high, :precision => 8, :scale => 2
      t.boolean :is_net, :null => false, :default => true
      t.date :expires_on

      
      t.references :priceable, :polymorphic => true

      t.timestamps
    end
  end

  def self.down
    drop_table :prices
  end
end

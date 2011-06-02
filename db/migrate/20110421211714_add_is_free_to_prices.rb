class AddIsFreeToPrices < ActiveRecord::Migration
  def self.up
    add_column :prices, :pricing_type, :string
  end

  def self.down
    remove_column :prices, :pricing_type
  end
end

class AddCurrencyToPrices < ActiveRecord::Migration
  def self.up
    add_column :prices, :currency, :string
  end

  def self.down
    remove_column :prices, :currency
  end
end

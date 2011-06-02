class AddPriceToAccountTypes < ActiveRecord::Migration
  def self.up
    add_column :account_types, :price_in_cents, :integer
  end

  def self.down
    remove_column :account_types, :price_in_cents
  end
end

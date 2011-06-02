class RemoveCurrencies < ActiveRecord::Migration
  def self.up
    drop_table :currencies
  end

  def self.down
    create_table :currencies do |t|
      t.string :entity
      t.string :currency
      t.string :alpha_code
      t.integer :numeric_code
      t.string :symbol
      t.timestamps
    end
  end
end

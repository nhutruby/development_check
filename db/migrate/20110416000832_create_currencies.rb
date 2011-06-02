class CreateCurrencies < ActiveRecord::Migration
  def self.up
    create_table :currencies do |t|
      t.string :entity
      t.string :currency
      t.string :alpha_code
      t.integer :numeric_code
      t.string :symbol
      t.timestamps
    end
  end

  def self.down
    drop_table :currencies
  end
end

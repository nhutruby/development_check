class CreateAddresses < ActiveRecord::Migration
  def self.up
    create_table :addresses do |t|
      t.string :line_1
      t.string :line_2
      t.string :city
      t.string :region
      t.string :postal_code
      t.string :country
      t.string :location

      t.timestamps
    end
  end

  def self.down
    drop_table :addresses
  end
end

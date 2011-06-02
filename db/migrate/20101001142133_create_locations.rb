class CreateLocations < ActiveRecord::Migration
  def self.up
    create_table :locations do |t|
      t.integer :address_id
      t.integer :primary_contact_id
      t.boolean :is_active

      t.timestamps
    end
  end

  def self.down
    drop_table :locations
  end
end

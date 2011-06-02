class CreateContactMethods < ActiveRecord::Migration
  def self.up
    create_table :contact_methods do |t|
      t.string :name
      t.string :location
      t.string :address
      t.integer :entity_id
      t.timestamps
    end
  end

  def self.down
    drop_table :addresses
  end
end

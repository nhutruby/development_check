class CreateParties < ActiveRecord::Migration
  def self.up
    create_table :parties do |t|
      t.integer :entity_id
      t.boolean :is_user
      t.boolean :is_organization
      t.timestamps
    end
  end

  def self.down
    drop_table :parties
  end
end

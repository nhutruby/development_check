class CreateOrganizations < ActiveRecord::Migration
  def self.up
    create_table :organizations do |t|
      t.string :name
      t.boolean :is_supplier
      t.boolean :is_provider
      t.boolean :is_consumer
      t.timestamps
    end
  end

  def self.down
    drop_table :organizations
  end
end

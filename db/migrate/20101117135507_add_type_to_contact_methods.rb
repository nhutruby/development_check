class AddTypeToContactMethods < ActiveRecord::Migration
  def self.up
    add_column :contact_methods, :entity_type, :string
  end

  def self.down
    remove_column :contact_methods, :entity_type
  end
end

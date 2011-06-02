class AddExtensionToContactMethods < ActiveRecord::Migration
  def self.up
    add_column :contact_methods, :extension, :string
  end

  def self.down
    remove_column :contact_methods, :extension
  end
end

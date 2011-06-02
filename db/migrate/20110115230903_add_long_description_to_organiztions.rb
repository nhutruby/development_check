class AddLongDescriptionToOrganiztions < ActiveRecord::Migration
  def self.up
    add_column :organizations, :long_description, :text
  end

  def self.down
    remove_column :organizations, :long_description
  end
end

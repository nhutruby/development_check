class AddDescriptionToOrganizations < ActiveRecord::Migration
  def self.up
    add_column :organizations, :description, :text
  end

  def self.down
    remove_column :organizations, :description
  end
end

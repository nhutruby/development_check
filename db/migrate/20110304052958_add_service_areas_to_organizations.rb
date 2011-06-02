class AddServiceAreasToOrganizations < ActiveRecord::Migration
  def self.up
    add_column :organizations, :service_areas, :text
  end

  def self.down
    remove_column :organizations, :service_areas
  end
end

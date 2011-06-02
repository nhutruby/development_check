class RenameOrganizationsServiceAreasToKeywords < ActiveRecord::Migration
  def self.up
    rename_column :organizations, :service_areas, :keywords
  end

  def self.down
    rename_column :organizations, :keywords, :service_areas
  end
end
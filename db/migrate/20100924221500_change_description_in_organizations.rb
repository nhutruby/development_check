class ChangeDescriptionInOrganizations < ActiveRecord::Migration
  def self.up
    change_column :organizations, :description, :string, :limit => 255
  end

  def self.down
  end
end

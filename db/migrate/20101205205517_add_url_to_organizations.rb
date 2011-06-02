class AddUrlToOrganizations < ActiveRecord::Migration
  def self.up
    add_column :organizations, :url, :string
  end

  def self.down
    remove_column :organizations, :url
  end
end

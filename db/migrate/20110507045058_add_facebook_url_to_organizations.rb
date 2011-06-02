class AddFacebookUrlToOrganizations < ActiveRecord::Migration
  def self.up
    add_column :organizations, :facebook_url, :string
  end

  def self.down
    remove_column :organizations, :facebook_url
  end
end

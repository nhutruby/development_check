class AddTwitterHandleToOrganizations < ActiveRecord::Migration
  def self.up
    add_column :organizations, :twitter_name, :string
  end

  def self.down
    remove_column :organizations, :twitter_name
  end
end

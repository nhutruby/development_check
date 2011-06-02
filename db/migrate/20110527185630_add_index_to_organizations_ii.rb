class AddIndexToOrganizationsIi < ActiveRecord::Migration
  def self.up
    add_index :organizations, [:id, :name]
  end

  def self.down
    remove_index :organizations, [:id, :name]
  end
end

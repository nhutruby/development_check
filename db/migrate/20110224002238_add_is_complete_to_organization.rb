class AddIsCompleteToOrganization < ActiveRecord::Migration
  def self.up
    add_column :organizations, :is_complete, :boolean
  end

  def self.down
    remove_column :organizations, :is_complete
  end
end

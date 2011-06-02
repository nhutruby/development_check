class RemoveIsClosedColumnsFromOrganizations < ActiveRecord::Migration
  def self.down
    add_column :organizations, :is_closed_count, :integer
    add_column :organizations, :is_closed_last_date, :datetime
  end

  def self.up
    remove_column :organizations, :is_closed_last_date
    remove_column :organizations, :is_closed_count
  end
end

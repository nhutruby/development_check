class AddIsClosedToOrganization < ActiveRecord::Migration
  def self.up
    add_column :organizations, :is_closed_count, :integer
    add_column :organizations, :is_closed_last_date, :datetime
  end

  def self.down
    remove_column :organizations, :is_closed_last_date
    remove_column :organizations, :is_closed_count
  end
end

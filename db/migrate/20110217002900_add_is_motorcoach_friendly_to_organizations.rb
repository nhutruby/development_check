class AddIsMotorcoachFriendlyToOrganizations < ActiveRecord::Migration
  def self.up
    add_column :organizations, :is_motorcoach_friendly, :boolean
  end

  def self.down
    remove_column :organizations, :is_motorcoach_friendly
  end
end

class AddSubscriptionIdAndProductIdToOrganizations < ActiveRecord::Migration
  def self.up
    add_column :organizations, :subscription_id, :integer
    add_column :organizations, :customer_id, :integer
  end

  def self.down
    remove_column :organizations, :customer_id
    remove_column :organizations, :subscription_id
  end
end

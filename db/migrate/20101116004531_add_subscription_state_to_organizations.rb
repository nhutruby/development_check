class AddSubscriptionStateToOrganizations < ActiveRecord::Migration
  def self.up
    add_column :organizations, :subscription_state, :string
  end

  def self.down
    remove_column :organizations, :subscription_state
  end
end

class AddIsTravelProviderToAccountTypes < ActiveRecord::Migration
  def self.up
    add_column :account_types, :is_travel_provider, :boolean
  end

  def self.down
    remove_column :account_types, :is_travel_provider
  end
end

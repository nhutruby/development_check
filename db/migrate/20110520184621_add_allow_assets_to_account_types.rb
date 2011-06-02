class AddAllowAssetsToAccountTypes < ActiveRecord::Migration
  def self.up
    add_column :account_types, :allow_assets, :boolean
  end

  def self.down
    remove_column :account_types, :allow_assets
  end
end

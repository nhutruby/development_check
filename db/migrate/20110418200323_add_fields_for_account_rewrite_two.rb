class AddFieldsForAccountRewriteTwo < ActiveRecord::Migration
  def self.up
    add_column :account_types, :link_to_chargify, :boolean, :default => false, :null => false
    add_index :account_types, :link_to_chargify
  end

  def self.down
    remove_index :account_types, :link_to_chargify
    remove_column :account_types, :link_to_chargify
    
  end
end
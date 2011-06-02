class AddDescriptionToAccountTypes < ActiveRecord::Migration
  def self.up
    add_column :account_types, :description, :text
  end

  def self.down
    remove_column :account_types, :description
  end
end

class ChangeFieldsForAccountType < ActiveRecord::Migration
  def self.up
    remove_column :account_types, :name
    remove_column :account_types, :price
    remove_column :account_types, :description
    add_column :account_types, :credits, :integer
    add_column :account_types, :product_id, :integer
  end

  def self.down
    add_column :account_types, :name, :string
    add_column :account_types, :price, :decimal
    add_column :account_types, :description, :text
    remove_column :account_types, :credits
    remove_column :account_types, :product_id
  end
end

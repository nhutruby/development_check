class AddFieldsForAccountRewriteThree < ActiveRecord::Migration
  def self.up
    add_column :organizations, :account_type_id, :integer
    #add_index :organizations, :account_type_id
  end

  def self.down
    #remove_index :organizations, :account_type_id
    remove_column :organizations, :account_type_id  
  end
end

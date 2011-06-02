class RecreateRoles < ActiveRecord::Migration
  def self.up
    create_table :roles do |t|
      t.integer :account_id
      t.integer :user_id
      t.boolean :is_owner
      t.boolean :is_admin      
      t.timestamps
    end
  end

  def self.down
    drop_table :roles
  end
end

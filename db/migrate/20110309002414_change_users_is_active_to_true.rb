class ChangeUsersIsActiveToTrue < ActiveRecord::Migration
  def self.up
    change_column :users, :is_active, :boolean, :default => true, :null => false
    remove_column :users, :inviter
    add_column :roles, :is_user_approved, :boolean, :default => nil
    rename_column :roles, :is_approved, :is_organization_approved
    add_column :organizations, :is_active, :boolean, :default => true
    rename_column :memberships, :is_approved, :is_organization_approved
    add_column :memberships, :is_user_approved, :boolean, :default => nil
    add_column :inventory_items, :is_active, :boolean, :default => true
    drop_table :friendships
  end

  def self.down
    change_column :users, :is_active, :boolean, :default => nil
    add_column :users, :inviter, :integer
    remove_column :roles, :is_user_approved
    rename_column :roles, :is_organization_approved, :is_approved
    remove_column :organizations, :is_active
    rename_column :memberships, :is_organization_approved, :is_approved
    remove_column :memberships, :is_user_approved
    remove_column :inventory_items, :is_active
    create_table :friendships do |t|
      t.integer :friendee_id
      t.integer :friender_id
      t.boolean :confirmed, :default => false
      t.string  :state,     :default => "requested"
      t.timestamps
    end
  end
end
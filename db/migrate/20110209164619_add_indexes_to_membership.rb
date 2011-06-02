class AddIndexesToMembership < ActiveRecord::Migration
  def self.up
    add_index :memberships, :organization_id
    add_index :memberships, :member_id
  end

  def self.down
    remove_index :memberships, :organization_id
    remove_index :memberships, :member_id
  end
end

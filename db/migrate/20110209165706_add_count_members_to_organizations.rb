class AddCountMembersToOrganizations < ActiveRecord::Migration
  def self.up
    add_column :organizations, :member_count, :integer
    add_index :organizations, :member_count

  end

  def self.down
    remove_index :organizations, :member_count
    remove_column :organizations, :member_count
  end
end

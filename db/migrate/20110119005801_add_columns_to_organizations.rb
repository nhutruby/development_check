class AddColumnsToOrganizations < ActiveRecord::Migration
  def self.up
    add_column :organizations, :syta_id, :integer
    add_column :organizations, :syta_email, :string
  end

  def self.down
    remove_column :organizations, :syta_email
    remove_column :organizations, :syta_id
  end
end

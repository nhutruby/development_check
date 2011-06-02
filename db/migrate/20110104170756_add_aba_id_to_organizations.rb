class AddAbaIdToOrganizations < ActiveRecord::Migration
  def self.up
    add_column :organizations, :aba_id, :integer
  end

  def self.down
    remove_column :organizations, :aba_id
  end
end

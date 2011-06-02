class AddAbaEmailAndAbaContactToOrganizations < ActiveRecord::Migration
  def self.up
    add_column :organizations, :aba_email, :string
    add_column :organizations, :aba_contact, :string
  end

  def self.down
    remove_column :organizations, :aba_contact
    remove_column :organizations, :aba_email
  end
end

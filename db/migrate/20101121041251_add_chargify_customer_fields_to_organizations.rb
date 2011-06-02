class AddChargifyCustomerFieldsToOrganizations < ActiveRecord::Migration
  def self.up
    add_column :organizations, :billing_first_name, :string
    add_column :organizations, :billing_last_name, :string
    add_column :organizations, :billing_email, :string
  end

  def self.down
    remove_column :organizations, :billing_email
    remove_column :organizations, :billing_last_name
    remove_column :organizations, :billing_first_name
  end
end

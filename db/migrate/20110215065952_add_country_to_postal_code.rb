class AddCountryToPostalCode < ActiveRecord::Migration
  def self.up
    add_column :postal_codes, :country, :string
  end

  def self.down
    remove_column :postal_codes, :country
  end
end

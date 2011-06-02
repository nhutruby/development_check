class AddEmailPrefsToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :email_newsletter, :boolean
    add_column :users, :email_special_offers, :boolean
  end

  def self.down
    remove_column :users, :email_special_offers
    remove_column :users, :email_newsletter
  end
end

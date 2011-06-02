class AddFieldsForAccountRewrite < ActiveRecord::Migration
  def self.up
    add_column :account_types, :name, :string
    add_column :account_types, :allow_website, :boolean, :default => false, :null => false
    add_column :account_types, :allow_email, :boolean, :default => false, :null => false
    add_column :account_types, :allow_logo, :boolean, :default => false, :null => false
    add_column :account_types, :allow_short_description, :boolean, :default => false, :null => false
    add_column :account_types, :allow_long_description, :boolean, :default => false, :null => false
    add_column :account_types, :allow_keywords, :boolean, :default => false, :null => false
    add_column :account_types, :allow_location_primary_contact, :boolean, :default => false, :null => false
    add_column :account_types, :allow_location_phone, :boolean, :default => false, :null => false
    add_column :account_types, :allow_location_website, :boolean, :default => false, :null => false
    add_column :account_types, :allow_tour_operator_search, :boolean, :default => false, :null => false
    add_column :account_types, :allow_association_directories, :boolean, :default => false, :null => false
    add_column :account_types, :allow_round_up, :boolean, :default => false, :null => false
    add_column :account_types, :allow_buyer_blast, :boolean, :default => false, :null => false
    add_column :account_types, :allow_enhance_listing, :boolean, :default => false, :null => false
    add_column :account_types, :user_limit, :integer
    add_column :account_types, :location_limit, :integer
    
    add_index :account_types, :name
    add_index :account_types, :allow_website
    add_index :account_types, :allow_email
    add_index :account_types, :allow_logo
    add_index :account_types, :allow_short_description
    add_index :account_types, :allow_long_description
    add_index :account_types, :allow_keywords
    add_index :account_types, :allow_location_primary_contact
    add_index :account_types, :allow_location_phone
    add_index :account_types, :allow_location_website
    add_index :account_types, :allow_tour_operator_search
    add_index :account_types, :allow_association_directories
    add_index :account_types, :allow_round_up
    add_index :account_types, :allow_buyer_blast
    add_index :account_types, :allow_enhance_listing
    add_index :account_types, :user_limit
    add_index :account_types, :location_limit
  end

  def self.down
    remove_index :account_types, :name
    remove_index :account_types, :allow_website
    remove_index :account_types, :allow_email
    remove_index :account_types, :allow_logo
    remove_index :account_types, :allow_short_description
    remove_index :account_types, :allow_long_description
    remove_index :account_types, :allow_keywords
    remove_index :account_types, :allow_location_primary_contact
    remove_index :account_types, :allow_location_phone
    remove_index :account_types, :allow_location_website
    remove_index :account_types, :allow_tour_operator_search
    remove_index :account_types, :allow_association_directories
    remove_index :account_types, :allow_round_up
    remove_index :account_types, :allow_buyer_blast
    remove_index :account_types, :allow_enhance_listing
    remove_index :account_types, :user_limit
    remove_index :account_types, :location_limit

    remove_column :account_types, :allow_website
    remove_column :account_types, :allow_email
    remove_column :account_types, :allow_logo
    remove_column :account_types, :allow_short_description
    remove_column :account_types, :allow_long_description
    remove_column :account_types, :allow_keywords
    remove_column :account_types, :allow_location_primary_contact
    remove_column :account_types, :allow_location_phone
    remove_column :account_types, :allow_location_website
    remove_column :account_types, :allow_tour_operator_search
    remove_column :account_types, :allow_association_directories
    remove_column :account_types, :allow_round_up
    remove_column :account_types, :allow_buyer_blast
    remove_column :account_types, :allow_enhance_listing
    remove_column :account_types, :user_limit
    remove_column :account_types, :name
    remove_column :account_types, :location_limit
    
  end
end

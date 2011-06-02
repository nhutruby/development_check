class AddIndexToPostalCodes < ActiveRecord::Migration
  def self.up
    add_index(:postal_codes, :code)
    add_index(:postal_codes, :city)
    add_index(:postal_codes, :region)
    add_index(:postal_codes, :country)
    
  end

  def self.down
    remove_index(:postal_codes, :code)
    remove_index(:postal_codes, :city)
    remove_index(:postal_codes, :region)
    remove_index(:postal_codes, :country)
  end
end

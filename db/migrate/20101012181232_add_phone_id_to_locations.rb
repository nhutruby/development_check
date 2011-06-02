class AddPhoneIdToLocations < ActiveRecord::Migration
  def self.up
    add_column :locations, :phone_id, :integer
  end

  def self.down
    remove_column :locations, :phone_id
  end
end

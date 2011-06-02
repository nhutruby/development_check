class AddMoreGeoToAddresses < ActiveRecord::Migration
  def self.up
    add_column :addresses, :accuracy, :float
  end

  def self.down
    remove_column :addresses, :accuracy
  end
end

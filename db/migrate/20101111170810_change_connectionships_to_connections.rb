class ChangeConnectionshipsToConnections < ActiveRecord::Migration
  def self.up
    rename_table :connectionships, :connections
  end

  def self.down
    rename_table :connections, :connectionships
  end
end

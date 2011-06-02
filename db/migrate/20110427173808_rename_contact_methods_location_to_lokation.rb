class RenameContactMethodsLocationToLokation < ActiveRecord::Migration
  def self.up
    rename_column :contact_methods, :location, :lokation
  end

  def self.down
    rename_column :contact_methods, :lokation, :location
  end
end
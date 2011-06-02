class PostalCodeRenameTypeToTipe < ActiveRecord::Migration
  def self.up
    rename_column :postal_codes, :type, :tipe
  end

  def self.down
    rename_column :postal_codes, :tipe, :type
  end
end


class RenameColumnInCategories < ActiveRecord::Migration
  def self.up
    rename_column :categories, :type, :tipe
  end

  def self.down
    rename_column :categories, :tipe, :type
  end
end

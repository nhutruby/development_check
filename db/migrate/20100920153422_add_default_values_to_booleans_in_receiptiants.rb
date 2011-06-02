class AddDefaultValuesToBooleansInReceiptiants < ActiveRecord::Migration
  def self.up
    change_column :receiptiants, :is_read, :boolean, :default => false, :null => false
    change_column :receiptiants, :is_deleted, :boolean, :default => false, :null => false
  end

  def self.down
  end
end

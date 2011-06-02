class AddColumnsToNotes < ActiveRecord::Migration
  def self.up
    add_column :notes, :is_fancybox_autoload, :boolean
  end

  def self.down
    remove_column :notes, :is_fancybox_autoload
  end
end

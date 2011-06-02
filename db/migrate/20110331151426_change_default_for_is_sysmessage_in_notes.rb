class ChangeDefaultForIsSysmessageInNotes < ActiveRecord::Migration
  def self.up
    change_column :notes, :is_sysmessage, :boolean, :default => false, :null => false
  end

  def self.down
    change_column :notes, :is_sysmessage, :boolean, :default => nil, :null => true
  end
end

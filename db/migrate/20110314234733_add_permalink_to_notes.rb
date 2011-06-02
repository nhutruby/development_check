class AddPermalinkToNotes < ActiveRecord::Migration
  def self.up
    add_column :notes, :permalink, :string
  end

  def self.down
    remove_column :notes, :permalink
  end
end

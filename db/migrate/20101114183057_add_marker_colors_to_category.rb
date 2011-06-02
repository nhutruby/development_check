class AddMarkerColorsToCategory < ActiveRecord::Migration
  def self.up
    add_column :categories, :marker_colors, :string
  end

  def self.down
    remove_column :categories, :marker_colors
  end
end

class CreateMarkerColors < ActiveRecord::Migration
  def self.up
    create_table :marker_colors do |t|
      t.string :color_name
      t.boolean :isactive

      t.timestamps
    end
  end

  def self.down
    drop_table :marker_colors
  end
end

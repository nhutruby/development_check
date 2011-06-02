class AddColorToCategories < ActiveRecord::Migration
  def self.up
    add_column :categories, :color, :string, :default => "#FFFFFF"
  end

  def self.down
    remove_column :categories, :color
  end
end

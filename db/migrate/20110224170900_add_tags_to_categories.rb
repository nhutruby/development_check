class AddTagsToCategories < ActiveRecord::Migration
  def self.up
    add_column :categories, :tags, :text
  end

  def self.down
    remove_column :categories, :tags
  end
end

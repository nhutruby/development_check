class AddSynonymToCategories < ActiveRecord::Migration
  def self.up
    add_column :categories, :synonym, :text
  end

  def self.down
    remove_column :categories, :synonym
  end
end

class AddIndexesToCategorizations < ActiveRecord::Migration
  def self.up
    add_index :categorizations, [:organization_id, :category_id]
    add_index :categories, :name
  end

  def self.down
    remove_index :categorizations, [:organization_id, :category_id]
    remove_index :categories, :name
  end
end

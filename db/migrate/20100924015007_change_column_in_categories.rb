class ChangeColumnInCategories < ActiveRecord::Migration
  def self.up
    remove_column :categories, :parent_id
    add_column :categories, :type, :string
  end

  def self.down
    add_column :categories, :parent_id, :integer
    remove_column :categories, :type
  end
end

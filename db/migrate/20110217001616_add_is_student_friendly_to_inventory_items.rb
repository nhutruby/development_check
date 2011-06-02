class AddIsStudentFriendlyToInventoryItems < ActiveRecord::Migration
  def self.up
    add_column :inventory_items, :is_student_friendly, :boolean
  end

  def self.down
    remove_column :inventory_items, :is_student_friendly
  end
end

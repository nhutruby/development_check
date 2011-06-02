class AddIsStudentFriendlyToOrganizations < ActiveRecord::Migration
  def self.up
    add_column :organizations, :is_student_friendly, :boolean
  end

  def self.down
    remove_column :organizations, :is_student_friendly
  end
end

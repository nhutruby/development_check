class ChangePersonIdToUserIdInReceiptiants < ActiveRecord::Migration
  def self.up
    remove_column :receiptiants, :person_id
    add_column :receiptiants, :user_id, :integer
  end

  def self.down
    remove_column :receiptiants, :user_id
    add_column :receiptiants, :person_id, :integer
  end
end

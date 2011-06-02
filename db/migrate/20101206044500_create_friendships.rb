class CreateFriendships < ActiveRecord::Migration
  def self.up
    create_table :friendships do |t|
      t.integer :friendee_id
      t.integer :friender_id
      t.boolean :confirmed, :default => false
      t.string  :state,     :default => "requested"
      t.timestamps
    end
  end

  def self.down
    drop_table :friendships
  end
end

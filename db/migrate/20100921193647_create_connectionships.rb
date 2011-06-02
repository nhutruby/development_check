class CreateConnectionships < ActiveRecord::Migration
  def self.up
    create_table :connectionships do |t|
      t.integer :user_id
      t.integer :connection_id

      t.timestamps
    end
  end

  def self.down
    drop_table :connectionships
  end
end

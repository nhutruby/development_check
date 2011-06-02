class CreateReceiptiants < ActiveRecord::Migration
  def self.up
    create_table :receiptiants do |t|
      t.integer :note_id
      t.integer :person_id
      t.boolean :is_read
      t.boolean :is_deleted

      t.timestamps
    end
  end

  def self.down
    drop_table :receiptiants
  end
end

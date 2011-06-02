class CreateNotes < ActiveRecord::Migration
  def self.up
    create_table :notes do |t|
      t.string :subject
      t.text :body
      t.datetime :occurred_at
      t.boolean :is_alert
      t.boolean :is_sysmessage
      t.integer :from_id

      t.timestamps
    end
  end

  def self.down
    drop_table :notes
  end
end

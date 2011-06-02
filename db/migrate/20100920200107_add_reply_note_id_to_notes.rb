class AddReplyNoteIdToNotes < ActiveRecord::Migration
  def self.up
    add_column :notes, :reply_id, :integer
  end

  def self.down
    remove_column :notes, :reply_id
  end
end

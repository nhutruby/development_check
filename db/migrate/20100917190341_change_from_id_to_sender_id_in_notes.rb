class ChangeFromIdToSenderIdInNotes < ActiveRecord::Migration
  def self.up
    rename_column :notes, :from_id, :sender_id
  end

  def self.down
    rename_column :notes, :sender_id, :from_id
  end
end

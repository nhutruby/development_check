class AddAttachmentAttachmentToAttachment < ActiveRecord::Migration
  def self.up
    create_table :attachments
    add_column :attachments, :attachment_file_name, :string
    add_column :attachments, :attachment_content_type, :string
    add_column :attachments, :attachment_file_size, :integer
    add_column :attachments, :attachment_updated_at, :datetime
    add_column :attachments, :attachable_id, :integer
    add_column :attachments, :attachable_type, :string
    add_column :attachments, :description, :text
  end

  def self.down
    drop_table :attachments
  end
end

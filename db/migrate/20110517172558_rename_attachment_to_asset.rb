class RenameAttachmentToAsset < ActiveRecord::Migration
  def self.up
    drop_table :attachments
    create_table :assets
    add_column :assets, :file_file_name, :string
    add_column :assets, :file_content_type, :string
    add_column :assets, :file_file_size, :integer
    add_column :assets, :file_updated_at, :datetime
    add_column :assets, :assetable_id, :integer
    add_column :assets, :assetable_type, :string
    add_column :assets, :description, :text
    add_column :assets, :name, :string
  end

  def self.down
    drop_table :assets
    create_table :attachments
    add_column :attachments, :attachment_file_name, :string
    add_column :attachments, :attachment_content_type, :string
    add_column :attachments, :attachment_file_size, :integer
    add_column :attachments, :attachment_updated_at, :datetime
    add_column :attachments, :attachable_id, :integer
    add_column :attachments, :attachable_type, :string
    add_column :attachments, :description, :text
  end
end

    

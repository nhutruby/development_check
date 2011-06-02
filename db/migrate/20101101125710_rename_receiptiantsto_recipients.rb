class RenameReceiptiantstoRecipients < ActiveRecord::Migration
  def self.up
    rename_table :receiptiants, :recipients
  end

  def self.down
    rename_table :recipients, :receiptiants
  end
end

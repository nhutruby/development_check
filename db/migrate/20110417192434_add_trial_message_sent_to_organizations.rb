class AddTrialMessageSentToOrganizations < ActiveRecord::Migration
  def self.up
    add_column :organizations, :trial_message_sent, :boolean
  end

  def self.down
    remove_column :organizations, :trial_message_sent
  end
end

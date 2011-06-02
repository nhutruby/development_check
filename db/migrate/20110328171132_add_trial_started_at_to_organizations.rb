class AddTrialStartedAtToOrganizations < ActiveRecord::Migration
  def self.up
    add_column :organizations, :trial_started_at, :datetime
  end

  def self.down
    remove_column :organizations, :trial_started_at
  end
end
class AddTrialEndsAtToOrganizations < ActiveRecord::Migration
  def self.up
    add_column :organizations, :trial_ends_at, :datetime
  end

  def self.down
    remove_column :organizations, :trial_ends_at
  end
end
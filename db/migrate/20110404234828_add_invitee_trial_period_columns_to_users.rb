class AddInviteeTrialPeriodColumnsToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :invitee_trial_period_days, :integer
    add_column :users, :invitee_trial_period_ends_at, :datetime
    add_column :users, :trial_period_ends_at, :datetime
  end

  def self.down
    remove_column :users, :invitee_trial_period_ends_at
    remove_column :users, :invitee_trial_period_days
    remove_column :users, :trial_period_ends_at
  end
end

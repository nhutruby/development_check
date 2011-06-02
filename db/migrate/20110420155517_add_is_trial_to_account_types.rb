class AddIsTrialToAccountTypes < ActiveRecord::Migration
  def self.up
    add_column :account_types, :is_trial, :boolean
  end

  def self.down
    remove_column :account_types, :is_trial
  end
end

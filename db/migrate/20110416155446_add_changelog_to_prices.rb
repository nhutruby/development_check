class AddChangelogToPrices < ActiveRecord::Migration
  def self.up
    add_column :prices, :changelog, :text
  end

  def self.down
    remove_column :prices, :changelog
  end
end

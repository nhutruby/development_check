class UpdateCategoriesData < ActiveRecord::Migration
  def self.up
    add_column :categories, :position, :integer
    # delete Group Leaders Passenger Unknown
    # id from db/fixtures/categories.rb
    #git commit Category.find(25, 26, 29).compact.map(&:destroy)
    puts "\n\nIMPORTANT: run `rake db:seed_fu FILTER=categories` to update Category data\n\n"
  end

  def self.down
    remove_column :categories, :position
  end
end
class CreatePostalCodes < ActiveRecord::Migration
  def self.up
    create_table :postal_codes do |t|
      t.string :code, :limit => 10
      t.string :city, :limit => 50
      t.string :region
      t.string :type, :limit => 25
      t.float :lat
      t.float :lng
      t.timestamps
    end
  end

  def self.down
    drop_table :postal_codes
  end
end

class CreateRatings < ActiveRecord::Migration
  def self.up
    create_table :ratings do |t|
      t.integer :stars
      t.integer :user_id
      t.boolean :is_closed
      t.boolean :is_open
      t.references :entity, :polymorphic => true
      t.timestamps
    end
  end

  def self.down
    drop_table :ratings
  end
end

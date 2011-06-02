class CreateMemberships < ActiveRecord::Migration
  def self.up
    create_table "memberships", :force => true do |t|
      t.integer  "member_id"
      t.integer  "organization_id"
      t.boolean  "is_approved",     :default => false, :null => false
      t.timestamps
    end
  end

  def self.down
  end
end




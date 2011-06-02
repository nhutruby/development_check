# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Daley', :city => cities.first)
 user = User.create(:password => '123456', :email=>"nhut2020@yahoo.com",  :name_first=>"Corey", :name_last=>"Black", :its_admin=>true, :email_messages=>true, :email_requests=>true, :is_travel_planner=>true, :is_active=>true, :is_deleted=>false, :currency=>"usd")

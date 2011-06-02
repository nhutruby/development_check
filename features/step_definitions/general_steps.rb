Given /^I have the following organizations?$/ do |table|
  table.hashes.each do |hash|
    organization = Organization.new(hash.merge(:creator_id => @user.id))
    organization.save
  end
end
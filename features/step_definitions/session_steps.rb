Given /^I am signed up and confirmed as (.+) "(.*)\/(.*)"$/ do |role, email, password|
  @user = Factory(:user, {:email => email, :password => password, :password_confirmation => password})
  @user.confirm!
  if role.eql?("admin")
    @user.its_admin = true
    @user.save
  end
end

When /^I sign in as "(.*)\/(.*)"$/ do |email, password|
When %{I go to the sign in page}
  And %{I fill in "user_email" with "#{email}"}
  And %{I fill in "user_password" with "#{password}"}
  And %{I press "Sign in"}
end

require 'test_helper'

class UserTest < ActiveSupport::TestCase
  test "should not save without first name" do
    user = User.new
    user.name_first = nil
    assert !user.save
  end
  test "should not save without last name" do
    user = User.new
    user.name_last = nil
    assert !user.save
  end
  test "should not save without email" do
    user = User.new
    user.email = nil
    assert !user.save
  end
end

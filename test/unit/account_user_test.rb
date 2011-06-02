require 'test_helper'

class AccountUserTest < ActiveSupport::TestCase
  def test_should_be_valid
    assert AccountUser.new.valid?
  end
end

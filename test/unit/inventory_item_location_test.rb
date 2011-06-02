require 'test_helper'

class InventoryItemLocationTest < ActiveSupport::TestCase
  def test_should_be_valid
    assert InventoryItemLocation.new.valid?
  end
end

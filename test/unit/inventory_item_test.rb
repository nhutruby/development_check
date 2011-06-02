require 'test_helper'

class InventoryItemTest < ActiveSupport::TestCase
  def test_should_be_valid
    assert InventoryItem.new.valid?
  end
end

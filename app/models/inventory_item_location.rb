class InventoryItemLocation < ActiveRecord::Base
  belongs_to :location
  belongs_to :inventory_item
  has_one :price, :as => :priceable
  accepts_nested_attributes_for :price
end

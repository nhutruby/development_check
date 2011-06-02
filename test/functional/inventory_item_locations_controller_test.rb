require 'test_helper'

class InventoryItemLocationsControllerTest < ActionController::TestCase
  def test_index
    get :index
    assert_template 'index'
  end
  
  def test_show
    get :show, :id => InventoryItemLocation.first
    assert_template 'show'
  end
  
  def test_new
    get :new
    assert_template 'new'
  end
  
  def test_create_invalid
    InventoryItemLocation.any_instance.stubs(:valid?).returns(false)
    post :create
    assert_template 'new'
  end
  
  def test_create_valid
    InventoryItemLocation.any_instance.stubs(:valid?).returns(true)
    post :create
    assert_redirected_to inventory_item_location_url(assigns(:inventory_item_location))
  end
  
  def test_edit
    get :edit, :id => InventoryItemLocation.first
    assert_template 'edit'
  end
  
  def test_update_invalid
    InventoryItemLocation.any_instance.stubs(:valid?).returns(false)
    put :update, :id => InventoryItemLocation.first
    assert_template 'edit'
  end
  
  def test_update_valid
    InventoryItemLocation.any_instance.stubs(:valid?).returns(true)
    put :update, :id => InventoryItemLocation.first
    assert_redirected_to inventory_item_location_url(assigns(:inventory_item_location))
  end
  
  def test_destroy
    inventory_item_location = InventoryItemLocation.first
    delete :destroy, :id => inventory_item_location
    assert_redirected_to inventory_item_locations_url
    assert !InventoryItemLocation.exists?(inventory_item_location.id)
  end
end

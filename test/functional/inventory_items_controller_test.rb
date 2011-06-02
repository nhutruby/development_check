require 'test_helper'

class InventoryItemsControllerTest < ActionController::TestCase
  def test_index
    get :index
    assert_template 'index'
  end
  
  def test_show
    get :show, :id => InventoryItem.first
    assert_template 'show'
  end
  
  def test_new
    get :new
    assert_template 'new'
  end
  
  def test_create_invalid
    InventoryItem.any_instance.stubs(:valid?).returns(false)
    post :create
    assert_template 'new'
  end
  
  def test_create_valid
    InventoryItem.any_instance.stubs(:valid?).returns(true)
    post :create
    assert_redirected_to inventory_item_url(assigns(:inventory_item))
  end
  
  def test_edit
    get :edit, :id => InventoryItem.first
    assert_template 'edit'
  end
  
  def test_update_invalid
    InventoryItem.any_instance.stubs(:valid?).returns(false)
    put :update, :id => InventoryItem.first
    assert_template 'edit'
  end
  
  def test_update_valid
    InventoryItem.any_instance.stubs(:valid?).returns(true)
    put :update, :id => InventoryItem.first
    assert_redirected_to inventory_item_url(assigns(:inventory_item))
  end
  
  def test_destroy
    inventory_item = InventoryItem.first
    delete :destroy, :id => inventory_item
    assert_redirected_to inventory_items_url
    assert !InventoryItem.exists?(inventory_item.id)
  end
end

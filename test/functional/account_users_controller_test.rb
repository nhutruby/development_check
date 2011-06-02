require 'test_helper'

class AccountUsersControllerTest < ActionController::TestCase
  def test_index
    get :index
    assert_template 'index'
  end
  
  def test_show
    get :show, :id => AccountUser.first
    assert_template 'show'
  end
  
  def test_new
    get :new
    assert_template 'new'
  end
  
  def test_create_invalid
    AccountUser.any_instance.stubs(:valid?).returns(false)
    post :create
    assert_template 'new'
  end
  
  def test_create_valid
    AccountUser.any_instance.stubs(:valid?).returns(true)
    post :create
    assert_redirected_to account_user_url(assigns(:account_user))
  end
  
  def test_edit
    get :edit, :id => AccountUser.first
    assert_template 'edit'
  end
  
  def test_update_invalid
    AccountUser.any_instance.stubs(:valid?).returns(false)
    put :update, :id => AccountUser.first
    assert_template 'edit'
  end
  
  def test_update_valid
    AccountUser.any_instance.stubs(:valid?).returns(true)
    put :update, :id => AccountUser.first
    assert_redirected_to account_user_url(assigns(:account_user))
  end
  
  def test_destroy
    account_user = AccountUser.first
    delete :destroy, :id => account_user
    assert_redirected_to account_users_url
    assert !AccountUser.exists?(account_user.id)
  end
end

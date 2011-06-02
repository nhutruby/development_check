require 'test_helper'

class ConnectionshipsControllerTest < ActionController::TestCase
  setup do
    @connectionship = connectionships(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:connectionships)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create connectionship" do
    assert_difference('Connectionship.count') do
      post :create, :connectionship => @connectionship.attributes
    end

    assert_redirected_to connectionship_path(assigns(:connectionship))
  end

  test "should show connectionship" do
    get :show, :id => @connectionship.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @connectionship.to_param
    assert_response :success
  end

  test "should update connectionship" do
    put :update, :id => @connectionship.to_param, :connectionship => @connectionship.attributes
    assert_redirected_to connectionship_path(assigns(:connectionship))
  end

  test "should destroy connectionship" do
    assert_difference('Connectionship.count', -1) do
      delete :destroy, :id => @connectionship.to_param
    end

    assert_redirected_to connectionships_path
  end
end

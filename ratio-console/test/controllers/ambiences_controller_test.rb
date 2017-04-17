require 'test_helper'

class AmbiencesControllerTest < ActionController::TestCase
  setup do
    @ambience = ambiences(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:ambiences)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create ambience" do
    assert_difference('Ambience.count') do
      post :create, ambience: { name: @ambience.name }
    end

    assert_redirected_to ambience_path(assigns(:ambience))
  end

  test "should show ambience" do
    get :show, id: @ambience
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @ambience
    assert_response :success
  end

  test "should update ambience" do
    patch :update, id: @ambience, ambience: { name: @ambience.name }
    assert_redirected_to ambience_path(assigns(:ambience))
  end

  test "should destroy ambience" do
    assert_difference('Ambience.count', -1) do
      delete :destroy, id: @ambience
    end

    assert_redirected_to ambiences_path
  end
end

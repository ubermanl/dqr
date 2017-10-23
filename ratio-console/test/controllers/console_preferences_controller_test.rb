require 'test_helper'

class ConsolePreferencesControllerTest < ActionController::TestCase
  setup do
    @console_preference = console_preferences(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:console_preferences)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create console_preference" do
    assert_difference('ConsolePreference.count') do
      post :create, console_preference: { graphic_interval: @console_preference.graphic_interval, graphic_refresh_interval: @console_preference.graphic_refresh_interval }
    end

    assert_redirected_to console_preference_path(assigns(:console_preference))
  end

  test "should show console_preference" do
    get :show, id: @console_preference
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @console_preference
    assert_response :success
  end

  test "should update console_preference" do
    patch :update, id: @console_preference, console_preference: { graphic_interval: @console_preference.graphic_interval, graphic_refresh_interval: @console_preference.graphic_refresh_interval }
    assert_redirected_to console_preference_path(assigns(:console_preference))
  end

  test "should destroy console_preference" do
    assert_difference('ConsolePreference.count', -1) do
      delete :destroy, id: @console_preference
    end

    assert_redirected_to console_preferences_path
  end
end

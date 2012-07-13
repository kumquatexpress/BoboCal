require 'test_helper'

class TimeperiodsControllerTest < ActionController::TestCase
  setup do
    @timeperiod = timeperiods(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:timeperiods)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create timeperiod" do
    assert_difference('Timeperiod.count') do
      post :create, :timeperiod => { :time => @timeperiod.time, :user_id => @timeperiod.user_id }
    end

    assert_redirected_to timeperiod_path(assigns(:timeperiod))
  end

  test "should show timeperiod" do
    get :show, :id => @timeperiod
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @timeperiod
    assert_response :success
  end

  test "should update timeperiod" do
    put :update, :id => @timeperiod, :timeperiod => { :time => @timeperiod.time, :user_id => @timeperiod.user_id }
    assert_redirected_to timeperiod_path(assigns(:timeperiod))
  end

  test "should destroy timeperiod" do
    assert_difference('Timeperiod.count', -1) do
      delete :destroy, :id => @timeperiod
    end

    assert_redirected_to timeperiods_path
  end
end

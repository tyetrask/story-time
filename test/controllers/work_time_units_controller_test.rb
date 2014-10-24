require 'test_helper'

class WorkTimeUnitsControllerTest < ActionController::TestCase
  setup do
    @work_time_unit = work_time_units(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:work_time_units)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create work_time_unit" do
    assert_difference('WorkTimeUnit.count') do
      post :create, work_time_unit: { finished_at: @work_time_unit.finished_at, story_id: @work_time_unit.story_id, started_at: @work_time_unit.started_at, total_time_in_seconds: @work_time_unit.total_time_in_seconds, user_id: @work_time_unit.user_id }
    end

    assert_redirected_to work_time_unit_path(assigns(:work_time_unit))
  end

  test "should show work_time_unit" do
    get :show, id: @work_time_unit
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @work_time_unit
    assert_response :success
  end

  test "should update work_time_unit" do
    patch :update, id: @work_time_unit, work_time_unit: { finished_at: @work_time_unit.finished_at, story_id: @work_time_unit.story_id, started_at: @work_time_unit.started_at, total_time_in_seconds: @work_time_unit.total_time_in_seconds, user_id: @work_time_unit.user_id }
    assert_redirected_to work_time_unit_path(assigns(:work_time_unit))
  end

  test "should destroy work_time_unit" do
    assert_difference('WorkTimeUnit.count', -1) do
      delete :destroy, id: @work_time_unit
    end

    assert_redirected_to work_time_units_path
  end
end

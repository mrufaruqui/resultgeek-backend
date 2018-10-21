require 'test_helper'

class WorkforcesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @workforce = workforces(:one)
  end

  test "should get index" do
    get workforces_url, as: :json
    assert_response :success
  end

  test "should create workforce" do
    assert_difference('Workforce.count') do
      post workforces_url, params: { workforce: { exam_uuid: @workforce.exam_uuid, role: @workforce.role, status: @workforce.status } }, as: :json
    end

    assert_response 201
  end

  test "should show workforce" do
    get workforce_url(@workforce), as: :json
    assert_response :success
  end

  test "should update workforce" do
    patch workforce_url(@workforce), params: { workforce: { exam_uuid: @workforce.exam_uuid, role: @workforce.role, status: @workforce.status } }, as: :json
    assert_response 200
  end

  test "should destroy workforce" do
    assert_difference('Workforce.count', -1) do
      delete workforce_url(@workforce), as: :json
    end

    assert_response 204
  end
end

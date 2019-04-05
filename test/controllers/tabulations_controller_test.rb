require 'test_helper'

class TabulationsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @tabulation = tabulations(:one)
  end

  test "should get index" do
    get tabulations_url, as: :json
    assert_response :success
  end

  test "should create tabulation" do
    assert_difference('Tabulation.count') do
      post tabulations_url, params: { tabulation: { gpa: @tabulation.gpa, remarks: @tabulation.remarks, result: @tabulation.result, student_roll: @tabulation.student_roll, tce: @tabulation.tce } }, as: :json
    end

    assert_response 201
  end

  test "should show tabulation" do
    get tabulation_url(@tabulation), as: :json
    assert_response :success
  end

  test "should update tabulation" do
    patch tabulation_url(@tabulation), params: { tabulation: { gpa: @tabulation.gpa, remarks: @tabulation.remarks, result: @tabulation.result, student_roll: @tabulation.student_roll, tce: @tabulation.tce } }, as: :json
    assert_response 200
  end

  test "should destroy tabulation" do
    assert_difference('Tabulation.count', -1) do
      delete tabulation_url(@tabulation), as: :json
    end

    assert_response 204
  end
end

require 'test_helper'

class TennatsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @tennat = tennats(:one)
  end

  test "should get index" do
    get tennats_url, as: :json
    assert_response :success
  end

  test "should create tennat" do
    assert_difference('Tennat.count') do
      post tennats_url, params: { tennat: { exam_id: @tennat.exam_id, exam_uuid: @tennat.exam_uuid } }, as: :json
    end

    assert_response 201
  end

  test "should show tennat" do
    get tennat_url(@tennat), as: :json
    assert_response :success
  end

  test "should update tennat" do
    patch tennat_url(@tennat), params: { tennat: { exam_id: @tennat.exam_id, exam_uuid: @tennat.exam_uuid } }, as: :json
    assert_response 200
  end

  test "should destroy tennat" do
    assert_difference('Tennat.count', -1) do
      delete tennat_url(@tennat), as: :json
    end

    assert_response 204
  end
end

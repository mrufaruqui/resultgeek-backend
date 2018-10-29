require 'test_helper'

class TenantsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @tenant = tenants(:one)
  end

  test "should get index" do
    get tenants_url, as: :json
    assert_response :success
  end

  test "should create tenant" do
    assert_difference('Tenant.count') do
      post tenants_url, params: { tenant: { exam: @tenant.exam, exam_uuid: @tenant.exam_uuid, login_time: @tenant.login_time, logout_time: @tenant.logout_time } }, as: :json
    end

    assert_response 201
  end

  test "should show tenant" do
    get tenant_url(@tenant), as: :json
    assert_response :success
  end

  test "should update tenant" do
    patch tenant_url(@tenant), params: { tenant: { exam: @tenant.exam, exam_uuid: @tenant.exam_uuid, login_time: @tenant.login_time, logout_time: @tenant.logout_time } }, as: :json
    assert_response 200
  end

  test "should destroy tenant" do
    assert_difference('Tenant.count', -1) do
      delete tenant_url(@tenant), as: :json
    end

    assert_response 204
  end
end

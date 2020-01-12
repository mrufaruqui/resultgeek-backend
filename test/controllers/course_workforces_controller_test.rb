require 'test_helper'

class CourseWorkforcesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @course_workforce = course_workforces(:one)
  end

  test "should get index" do
    get course_workforces_url, as: :json
    assert_response :success
  end

  test "should create course_workforce" do
    assert_difference('CourseWorkforce.count') do
      post course_workforces_url, params: { course_workforce: {  } }, as: :json
    end

    assert_response 201
  end

  test "should show course_workforce" do
    get course_workforce_url(@course_workforce), as: :json
    assert_response :success
  end

  test "should update course_workforce" do
    patch course_workforce_url(@course_workforce), params: { course_workforce: {  } }, as: :json
    assert_response 200
  end

  test "should destroy course_workforce" do
    assert_difference('CourseWorkforce.count', -1) do
      delete course_workforce_url(@course_workforce), as: :json
    end

    assert_response 204
  end
end

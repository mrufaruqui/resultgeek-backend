require 'test_helper'

class CoursesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @course = courses(:one)
  end

  test "should get index" do
    get courses_url
    assert_response :success
  end

  test "should get new" do
    get new_course_url
    assert_response :success
  end

  test "should create course" do
    assert_difference('Course.count') do
      post courses_url, params: { course: { assesment: @course.assesment, attendance: @course.attendance, grade: @course.grade, marks: @course.marks, percentage: @course.percentage, section_a_marks: @course.section_a_marks, section_b_marks: @course.section_b_marks, total_marks: @course.total_marks } }
    end

    assert_redirected_to course_url(Course.last)
  end

  test "should show course" do
    get course_url(@course)
    assert_response :success
  end

  test "should get edit" do
    get edit_course_url(@course)
    assert_response :success
  end

  test "should update course" do
    patch course_url(@course), params: { course: { assesment: @course.assesment, attendance: @course.attendance, grade: @course.grade, marks: @course.marks, percentage: @course.percentage, section_a_marks: @course.section_a_marks, section_b_marks: @course.section_b_marks, total_marks: @course.total_marks } }
    assert_redirected_to course_url(@course)
  end

  test "should destroy course" do
    assert_difference('Course.count', -1) do
      delete course_url(@course)
    end

    assert_redirected_to courses_url
  end
end

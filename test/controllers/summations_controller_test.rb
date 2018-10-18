require 'test_helper'

class SummationsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @summation = summations(:one)
  end

  test "should get index" do
    get summations_url, as: :json
    assert_response :success
  end

  test "should create summation" do
    assert_difference('Summation.count') do
      post summations_url, params: { summation: { assesment: @summation.assesment, attendance: @summation.attendance, gpa: @summation.gpa, grade: @summation.grade, section_a_marks: @summation.section_a_marks, section_b_marks: @summation.section_b_marks, total_marks: @summation.total_marks } }, as: :json
    end

    assert_response 201
  end

  test "should show summation" do
    get summation_url(@summation), as: :json
    assert_response :success
  end

  test "should update summation" do
    patch summation_url(@summation), params: { summation: { assesment: @summation.assesment, attendance: @summation.attendance, gpa: @summation.gpa, grade: @summation.grade, section_a_marks: @summation.section_a_marks, section_b_marks: @summation.section_b_marks, total_marks: @summation.total_marks } }, as: :json
    assert_response 200
  end

  test "should destroy summation" do
    assert_difference('Summation.count', -1) do
      delete summation_url(@summation), as: :json
    end

    assert_response 204
  end
end

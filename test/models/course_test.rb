# == Schema Information
#
# Table name: courses
#
#  id          :integer          not null, primary key
#  title       :string(255)
#  code        :string(255)
#  credit      :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  course_type :integer          default("theory")
#  sl_no       :integer
#  exam_uuid   :string(255)
#  exam_id     :integer
#

require 'test_helper'

class CourseTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end

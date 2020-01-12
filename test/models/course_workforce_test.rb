# == Schema Information
#
# Table name: course_workforces
#
#  id         :integer          not null, primary key
#  exam_uuid  :string(255)
#  course_id  :integer
#  teacher_id :integer
#  status     :integer          default("active")
#  role       :integer          default("instructor")
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'test_helper'

class CourseWorkforceTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end

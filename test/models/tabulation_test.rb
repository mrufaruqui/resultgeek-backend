# == Schema Information
#
# Table name: tabulations
#
#  id             :integer          not null, primary key
#  student_roll   :integer
#  gpa            :float(24)
#  tce            :float(24)
#  result         :string(255)
#  remarks        :string(255)
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  record_type    :integer          default("current")
#  sl_no          :integer
#  exam_uuid      :string(255)
#  student_type   :integer          default("regular")
#  hall_name      :string(255)
#  tps            :integer          default(0)
#  course_details :text(65535)
#

require 'test_helper'

class TabulationTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end

# == Schema Information
#
# Table name: courses
#
#  id              :integer          not null, primary key
#  section_a_marks :float(24)
#  section_b_marks :float(24)
#  attendance      :float(24)
#  assesment       :float(24)
#  grade           :integer
#  marks           :float(24)
#  total_marks     :float(24)
#  percentage      :float(24)
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

require 'test_helper'

class CourseTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end

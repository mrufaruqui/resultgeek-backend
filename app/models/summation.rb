# == Schema Information
#
# Table name: summations
#
#  id              :integer          not null, primary key
#  assesment       :float(24)
#  attendance      :float(24)
#  section_a_marks :float(24)
#  section_b_marks :float(24)
#  total_marks     :float(24)
#  gpa             :string(255)
#  grade           :float(24)
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  section_a_code  :string(255)
#  section_b_code  :string(255)
#  student_id      :integer
#  course_id       :integer
#  marks           :string(255)
#  remarks         :string(255)
#  percetage       :float(24)
#  cact            :float(24)
#  exam_uuid       :string(255)
#

class Summation < ApplicationRecord
      enum record_type: [:current, :previous]
      belongs_to :student
      belongs_to :course
end

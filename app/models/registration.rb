# == Schema Information
#
# Table name: registrations
#
#  id           :integer          not null, primary key
#  exam_id      :integer
#  student_id   :integer
#  student_type :integer          default(0)
#  course_list  :string(255)
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

class Registration < ApplicationRecord
     belongs_to :student
     belongs_to :exam
end

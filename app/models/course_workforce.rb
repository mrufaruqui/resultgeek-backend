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

class CourseWorkforce < ApplicationRecord
    belongs_to :course
    belongs_to :teacher  
    enum role: [:instructor, :examiner, :section_a_examiner, :section_b_examiner, :course_teacher, :co_instructor]
    enum status: [:active, :inactive]
end

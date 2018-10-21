# == Schema Information
#
# Table name: workforces
#
#  id         :integer          not null, primary key
#  role       :string(255)      default("member")
#  status     :integer
#  exam_uuid  :string(255)      not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  exam_id    :integer
#  teacher_id :integer
#

class Workforce < ApplicationRecord
     belongs_to :exam
     belongs_to :teacher
     enum designation: [:member, :chairman,:tabulator, :scritinizer, :instructor, :examiner, :section_a_examiner, :section_b_examiner, :course_teacher]
     enum status: [:active, :inactive]
end

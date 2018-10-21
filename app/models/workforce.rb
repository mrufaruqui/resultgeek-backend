class Workforce < ApplicationRecord
     belongs_to: :exam
     belongs_to: :teacher
     enum designation: [:member, :chairman,:tabulator, :scritinizer, :instructor, :examiner, :section_a_examiner, :section_b_examiner, :course_teacher]
     enum status: [:active, :inactive]
end

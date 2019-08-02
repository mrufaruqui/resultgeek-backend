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
#  course_details :text(a)
#

class Tabulation < ApplicationRecord
    serialize :course_details
    enum student_type: [:regular, :improvement, :irregular]
    enum record_type: [:current, :previous, :temp]
    #belongs_to :student
    has_many   :tabulation_details,:dependent=> :destroy
    scope :with_tabulation_details, -> {includes(:tabulation_details)} 
end

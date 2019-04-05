# == Schema Information
#
# Table name: tabulations
#
#  id           :integer          not null, primary key
#  student_id   :integer
#  gpa          :float(24)
#  tce          :float(24)
#  result       :string(255)
#  remarks      :string(255)
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  exam_uuid    :string(255)
#  sl_no        :integer
#  student_type :integer          default("regular")
#  record_type  :integer          default("current")
#

class Tabulation < ApplicationRecord
    enum student_type: [:regular, :improvement, :irregular]
    enum record_type: [:current, :previous, :temp]
    #belongs_to :student
    has_many   :tabulation_details,:dependent=> :destroy
    scope :with_tabulation_details, -> {includes(:tabulation_details)} 
end

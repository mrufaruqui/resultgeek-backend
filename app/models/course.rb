# == Schema Information
#
# Table name: courses
#
#  id          :integer          not null, primary key
#  title       :string(255)
#  code        :string(255)
#  credit      :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  course_type :integer          default("theory")
#  sl_no       :integer
#  exam_uuid   :string(255)
#  exam_id     :integer
#

class Course < ApplicationRecord
    #before_create :set_exam_uuid

    enum course_type: [:theory, :lab]
    default_scope { order(:sl_no) }
    belongs_to :exam


    def self.import(students_info) 
      header = students_info[0]
      body = students_info - [header]
      body.each do |i| 
        row = Hash[[header, i].transpose].symbolize_keys
        student = Student.find_by(roll: row[:roll]) || new
        student.roll = row[:roll]
        student.name = row[:name]
        student.hall_name = row[:hall_name]
        student.hall = row[:hall] 
        student.save
      end
    end


    # private 
    #  def set_exam_uuid
    #     # session = Session.find_by(uuid:current_user.session_uuid)
    #      @exam = Exam.find_by(uuid: Exam.first.uuid) #@session.exam_uuid)
    #      self.exam_uuid = @exam.uuid 
    #   end
end

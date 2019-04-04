# == Schema Information
#
# Table name: registrations
#
#  id           :integer          not null, primary key
#  exam_id      :integer
#  student_id   :integer
#  student_type :integer          default("regular")
#  course_list  :string(255)
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  exam_uuid    :string(255)
#  sl_no        :integer
#

class Registration < ApplicationRecord
     enum student_type: [:regular, :improvement]
     belongs_to :student
     belongs_to :exam


    #  def self.register(options) 
    #   header = options[:students_info][0]
    #   body =   options[:students_info] - [header]
    #   body.each do |i| 
    #     row = Hash[[header, i].transpose].symbolize_keys
    #     student = find_by(roll: row[:roll]) || new
    #     student.roll = row[:roll]
    #     student.name = row[:name]
    #     student.hall_name = row[:hall_name]
    #     student.hall = row[:hall] 
    #     student.save
    #     registration = Registration.find_by(student_id: student.id) || Registration.new
    #     registration.exam_id = options[:exam].id
    #     registration.student_type = row[:type]
    #     registration.course_list=row[:courses]
    #     registration.save
    #   end
    # end
end

class Summation < ApplicationRecord
    def self.import(data)
      course = Course.find_by(code: 'CSE111') #ToDo
      header = data[0]
      body = data - [header]
      body.each do |i| 
        row = Hash[[header, i].transpose].symbolize_keys
        student = Student.find_by(roll: row[:roll]) || new
        summataion = find_by(id: row[:id]) || new
        summataion.student = student
        summation.course   = course 
        summataion.assesment = row[:ct]
        summataion.attendance = row[:ca]
        summataion.section_a_marks = row[:marks_a]
        summataion.section_b_marks = row[:marks_b]
        summataion.section_a_code = row[:code_a]
        summataion.section_b_code = row[:code_b]
        summataion.save
      end
    end
end

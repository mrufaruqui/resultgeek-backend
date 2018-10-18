# == Schema Information
#
# Table name: students
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  roll       :integer
#  hall       :integer
#  hall_name  :string(255)
#  gpa        :float(24)
#  status     :integer          default(0)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Student < ApplicationRecord
  require 'roo'
    attr_accessor :file
    attr_accessor :students_info

    # def self.import(file)
    #   spreadsheet = Roo::Spreadsheet.open(file.path)
    #   header = spreadsheet.row(1)
    #   (2..spreadsheet.last_row).each do |i|
    #     row = Hash[[header, spreadsheet.row(i)].transpose].symbolize_keys
    #     student = find_by(roll: row[:roll]) || new
    #     student.roll = row[:roll]
    #     student.name = row[:name]
    #     student.hall_name = row[:hall_name]
    #     student.hall = row[:hall]
    #     #student.attributes = row.to_hash.re
    #     student.save
    #   end
    # end

    def self.import(students_info) 
      header = students_info[0]
      body = students_info - [header]
      body.each do |i| 
        row = Hash[[header, i].transpose].symbolize_keys
        student = find_by(roll: row[:roll]) || new
        student.roll = row[:roll]
        student.name = row[:name]
        student.hall_name = row[:hall_name]
        student.hall = row[:hall] 
        student.save
      end
    end
end

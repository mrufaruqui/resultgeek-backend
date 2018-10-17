# == Schema Information
#
# Table name: courses
#
#  id              :integer          not null, primary key
#  section_a_marks :float(24)
#  section_b_marks :float(24)
#  attendance      :float(24)
#  assesment       :float(24)
#  grade           :integer
#  marks           :float(24)
#  total_marks     :float(24)
#  percentage      :float(24)
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

class Course < ApplicationRecord
    require 'roo'
    attr_accessor :file

    def self.import(file)
      spreadsheet = Roo::Spreadsheet.open(file.path)
      header = spreadsheet.row(1)
      (2..spreadsheet.last_row).each do |i|
        row = Hash[[header, spreadsheet.row(i)].transpose].symbolize_keys
        course = find_by(id: row[:id]) || new
        course.attendance = row[:ca]
        course.assesment = row[:ct]
        course.section_a_marks = row[:section_a]
        course.section_b_marks = row[:section_b]
        course.marks = course.section_a_marks + course.section_b_marks
        course.total_marks = course.marks + course.attendance + course.assesment
        course.save
      end
    end

    
end

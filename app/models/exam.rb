# == Schema Information
#
# Table name: exams
#
#  id           :integer          not null, primary key
#  sem          :integer          default("_first")
#  year         :string(255)
#  program      :integer          default("bsc")
#  title        :string(255)
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  uuid         :string(255)
#  program_type :integer
#

class Exam < ApplicationRecord
    enum sem: [ :_first, :_second, :_third, :_fourth, :_sixth, :_seventh, :_eight ]
    enum program: [:bsc, :msc, :mphil, :phd]
    enum program_type: [:semester, :year, :term]

    has_many :workforces
    has_many :teachers, through: :workforces

    has_many :registrations
    has_many :students, through: :registrations


    def fullname
      [ sem, program_type,  program,"Engineering Exam",   year].join(" ").titlecase
    end
 
end

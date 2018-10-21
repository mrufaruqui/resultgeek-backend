# == Schema Information
#
# Table name: exams
#
#  id         :integer          not null, primary key
#  sem        :integer          default("_first")
#  year       :string(255)
#  program    :integer          default("bsc")
#  title      :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  uuid       :string(255)
#  fullname   :string(255)
#

class Exam < ApplicationRecord
    enum sem: [ :_first, :_second, :_third, :_fourth ]
    enum program: [:bsc, :msc, :mphil, :phd]
    enum program_type: [:semester, :year, :term]

    has_many :workforces
    has_many :teachers, through: :workforces

    def fullname
      [ sem.titlecase, program_type.titlecase,  program.titlecase,"Engineering Exam",   year].join(" ")
    end

    # def self.uuid
    #   [sem, program, title, year].join("")
    # end
end

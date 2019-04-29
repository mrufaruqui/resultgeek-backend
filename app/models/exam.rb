# == Schema Information
#
# Table name: exams
#
#  id           :integer          not null, primary key
#  year         :string(255)
#  title        :string(255)
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  held_in      :string(255)
#  uuid         :string(255)
#  sem          :integer          default("_first")
#  program      :integer          default("bsc")
#  program_type :integer          default("semester")
#

class Exam < ApplicationRecord
    #validates :uuid, presence: true
    enum sem: [:_first, :_second, :_third, :_fourth, :_fifth, :_sixth, :_seventh, :_eight ]
    enum program: [:bsc, :msc, :mphil, :phd]
    enum program_type: [:semester, :year, :term]

    has_many :workforces
    has_many :teachers, through: :workforces

    has_many :registrations
    has_many :students, through: :registrations

    has_many :courses


    def fullname
      [ sem, program_type,  program,"Engineering Exam",   year].join(" ").titlecase
    end
 
end

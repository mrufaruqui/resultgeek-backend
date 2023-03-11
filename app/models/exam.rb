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
#  program      :integer          default("BSc")
#  program_type :integer          default("semester")
#

class Exam < ApplicationRecord
  include ActiveModel::Serializers::JSON
    #validates :uuid, presence: true
    enum sem: [:_first, :_second, :_third, :_fourth, :_fifth, :_sixth, :_seventh, :_eight ]
    enum program: ["BSc", "MSc", "MPhil", "Phd"]
    enum program_type: [:semester, :year, :term]

    has_many :workforces
    has_many :teachers, through: :workforces

    has_many :registrations
    has_many :students, through: :registrations

    has_many :courses
 
    belongs_to :dept
    before_create :set_title 

    def fullname
      title
     # prgram_name = program == :BSc ? " BSc " : " MSc "
     # [ sem, program_type].join(" ").titlecase  + prgram_name +["Engineering Examination",   year].join(" ").titlecase
    end
 
  private
      def set_title
        self.title = [ sem.titlecase, program_type.titlecase,  program,"Engineering Examination",   year].join(" ")
      end
end

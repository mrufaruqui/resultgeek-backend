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
#

class Exam < ApplicationRecord
    enum sem: [ :_first, :_second, :_third, :_fourth ]
    enum program: [:bsc, :msc, :mphil, :phd]
    has_many: :workforces
    has_many: :teachers, through: :workforces
end

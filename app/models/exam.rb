# == Schema Information
#
# Table name: exams
#
#  id                            :integer          not null, primary key
#  title                         :string(255)
#  sem                           :integer          default("_first")
#  year                          :string(255)
#  program                       :integer          default("bsc")
#  registered_regular_students   :integer
#  registered_irregular_students :integer
#  passed                        :integer
#  failed                        :integer
#  created_at                    :datetime         not null
#  updated_at                    :datetime         not null
#

class Exam < ApplicationRecord
    enum sem: [ :_first, :_second, :_third, :_fourth ]
    enum program: [:bsc, :msc, :mphil, :phd]
end

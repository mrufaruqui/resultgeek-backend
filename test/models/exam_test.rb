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

require 'test_helper'

class ExamTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end

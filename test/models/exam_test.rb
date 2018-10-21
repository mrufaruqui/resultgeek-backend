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

require 'test_helper'

class ExamTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end

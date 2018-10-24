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

require 'test_helper'

class ExamTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end

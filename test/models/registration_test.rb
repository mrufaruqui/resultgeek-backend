# == Schema Information
#
# Table name: registrations
#
#  id           :integer          not null, primary key
#  exam_id      :integer
#  student_id   :integer
#  student_type :integer          default("regular")
#  course_list  :string(255)
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  exam_uuid    :string(255)
#

require 'test_helper'

class RegistrationTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end

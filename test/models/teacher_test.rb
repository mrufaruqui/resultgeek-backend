# == Schema Information
#
# Table name: teachers
#
#  id          :integer          not null, primary key
#  title       :string(255)
#  fullname    :string(255)
#  designation :integer          default("professor")
#  dept_id     :integer
#  address     :string(255)
#  email       :string(255)
#  phone       :integer
#  status      :integer          default("active")
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  sl_no       :integer
#

require 'test_helper'

class TeacherTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end

# == Schema Information
#
# Table name: tabulations
#
#  id         :integer          not null, primary key
#  student_id :integer
#  gpa        :float(24)
#  tce        :float(24)
#  result     :string(255)
#  remarks    :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'test_helper'

class TabulationTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end

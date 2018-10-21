# == Schema Information
#
# Table name: workforces
#
#  id         :integer          not null, primary key
#  role       :string(255)      default("member")
#  status     :integer
#  exam_uuid  :string(255)      not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  exam_id    :integer
#  teacher_id :integer
#

require 'test_helper'

class WorkforceTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end

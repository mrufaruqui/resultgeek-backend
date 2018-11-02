# == Schema Information
#
# Table name: tenants
#
#  id          :integer          not null, primary key
#  exam_id     :integer
#  exam_uuid   :string(255)
#  login_time  :datetime
#  logout_time :datetime
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

require 'test_helper'

class TenantTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end

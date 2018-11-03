# == Schema Information
#
# Table name: depts
#
#  id             :integer          not null, primary key
#  name           :string(255)
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  code           :string(255)
#  institute      :string(255)
#  institute_code :string(255)
#

require 'test_helper'

class DeptTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end

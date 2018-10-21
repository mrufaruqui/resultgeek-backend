# == Schema Information
#
# Table name: tabulation_details
#
#  id            :integer          not null, primary key
#  summation_id  :integer
#  tabulation_id :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

class TabulationDetail < ApplicationRecord
    belongs_to :tabulation
    belongs_to :summation
end

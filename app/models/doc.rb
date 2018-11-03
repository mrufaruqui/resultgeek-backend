# == Schema Information
#
# Table name: docs
#
#  id          :integer          not null, primary key
#  exam_uuid   :string(255)
#  uuid        :string(255)
#  latex_name  :string(255)
#  latex_loc   :string(255)
#  pdf_name    :string(255)
#  pdf_loc     :string(255)
#  xls_name    :string(255)
#  xls_loc     :string(255)
#  description :string(255)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class Doc < ApplicationRecord
end

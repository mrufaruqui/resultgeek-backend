# == Schema Information
#
# Table name: sessions
#
#  id         :integer          not null, primary key
#  uuid       :string(255)      not null
#  exam_uuid  :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Session < ApplicationRecord
    before_create :set_uuid

    private
    def set_uuid
      self.uuid = SecureRandom.urlsafe_base64(16)
    end
end

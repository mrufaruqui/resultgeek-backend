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

class Teacher < ApplicationRecord
    enum designation: [:professor, :associate_professor, :assistant_professor, :lecturer]
    enum status: [:active, :on_leave, :retired, :resigned]
    has_many :workforces
    has_many :exams, through: :workforces
    belongs_to  :dept
    default_scope { order(:designation)}
    default_scope { includes(:dept)}

    def display_name
      if designation == "professor"
        ["Prof.", title, fullname].join(' ')
      else
        [title, fullname].join(' ')
      end
    end

end

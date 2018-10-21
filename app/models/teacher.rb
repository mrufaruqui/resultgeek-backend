class Teacher < ApplicationRecord
    enum designation: [:professor, :associate_professor, :assistant_professor, :lecturer]
    enum status: [:active, :on_leave, :retired, :resigned]
    has_many: :workforces
    has_many: :exams, through: :workforces
end

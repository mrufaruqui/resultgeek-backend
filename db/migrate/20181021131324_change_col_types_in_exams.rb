class ChangeColTypesInExams < ActiveRecord::Migration[5.1]
  def change
     change_column :exams, :sem, :string, default: :_first
     change_column :exams, :program, :string, default: :BSc
     change_column :exams, :program_type, :string, default: :semester
  end
end

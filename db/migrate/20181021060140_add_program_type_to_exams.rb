class AddProgramTypeToExams < ActiveRecord::Migration[5.1]
  def change
    add_column :exams, :program_type, :integer, limit:1, default: "semester"
  end
end

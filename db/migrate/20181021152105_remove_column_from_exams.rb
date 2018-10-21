class RemoveColumnFromExams < ActiveRecord::Migration[5.1]
  def change
    remove_column :exams, :sem, :string
    remove_column :exams, :program, :string
    remove_column :exams, :program_type, :string
  end
end

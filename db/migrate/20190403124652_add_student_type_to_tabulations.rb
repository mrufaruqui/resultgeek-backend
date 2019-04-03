class AddStudentTypeToTabulations < ActiveRecord::Migration[5.1]
  def change
    add_column :tabulations, :student_type, :integer, limit:1, default: 0 
  end
end

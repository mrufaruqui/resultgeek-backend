class AddColumnsToExams < ActiveRecord::Migration[5.1]
  def change 
    add_column :exams, :sem, :integer, limit:1, default:0
    add_column :exams, :program, :integer, limit:1, default:0
    add_column :exams, :program_type, :integer, limit:1, default:0
  end
end

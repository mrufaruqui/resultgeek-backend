class AddDeptIdToExams < ActiveRecord::Migration[6.1]
  def change
    add_reference :exams, :dept, index: true 
  end
end

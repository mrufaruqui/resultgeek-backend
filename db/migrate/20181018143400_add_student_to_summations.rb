class AddStudentToSummations < ActiveRecord::Migration[5.1]
  def change
    add_reference :summations, :student, index: true 
  end
end

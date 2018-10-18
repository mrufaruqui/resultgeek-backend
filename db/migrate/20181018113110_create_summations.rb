class CreateSummations < ActiveRecord::Migration[5.1]
  def change
    create_table :summations do |t|
      t.float :assesment
      t.float :attendance
      t.float :section_a_marks
      t.float :section_b_marks
      t.float :total_marks
      t.string :gpa
      t.float :grade

      t.timestamps
    end
  end
end

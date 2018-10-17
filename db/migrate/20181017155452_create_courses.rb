class CreateCourses < ActiveRecord::Migration[5.1]
  def change
    create_table :courses do |t|
      t.float :section_a_marks
      t.float :section_b_marks
      t.float :attendance
      t.float :assesment
      t.integer :grade
      t.float :marks
      t.float :total_marks
      t.float :percentage

      t.timestamps
    end
  end
end

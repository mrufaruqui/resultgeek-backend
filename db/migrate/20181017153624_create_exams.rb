class CreateExams < ActiveRecord::Migration[5.1]
  def change
    create_table :exams do |t|
      t.string :title
      t.integer :sem, limit:1, default:0
      t.string :year
      t.integer :program, limit:1, default:0
      t.integer :registered_regular_students
      t.integer :registered_irregular_students
      t.integer :passed
      t.integer :failed

      t.timestamps
    end
  end
end

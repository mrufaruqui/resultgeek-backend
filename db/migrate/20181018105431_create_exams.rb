class CreateExams < ActiveRecord::Migration[5.1]
  def change
    create_table :exams do |t|
      t.integer :sem, limit:1, default:0
      t.string :year
      t.integer :program, limit:1, default:0
      t.string :title
      t.timestamps
    end
  end
end

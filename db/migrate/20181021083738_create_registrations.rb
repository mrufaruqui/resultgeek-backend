class CreateRegistrations < ActiveRecord::Migration[5.1]
  def change
    create_table :registrations do |t| 
      t.belongs_to :exam, index: true, foreign_key: true
      t.belongs_to :student, index: true, foreign_key: true
      t.integer :student_type, limit:1, default: 0
      t.string :course_list

      t.timestamps
    end
  end
end

class CreateCourseWorkforces < ActiveRecord::Migration[5.1]
  def change
    create_table :course_workforces do |t|
      t.string :exam_uuid, :unique => true
      t.belongs_to :course, index: true, foreign_key: true
      t.belongs_to :teacher, index: true, foreign_key: true
      t.integer :status, limit:1, default:0
      t.integer :role, limit:1, default:0
      t.timestamps
    end
  end 
end

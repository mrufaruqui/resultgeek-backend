class CreateTabulations < ActiveRecord::Migration[5.1]
  def change
    create_table :tabulations do |t| 
      t.integer :student_roll
      t.float :gpa
      t.float :tce
      t.string :result
      t.string :remarks
      t.timestamps
      t.integer :record_type,  limit:1, default: 0 
      t.integer :sl_no
      t.string :exam_uuid
    end

    add_index :tabulations, [:student_roll, :exam_uuid, :record_type], name: "registered_student_record"
  end
end

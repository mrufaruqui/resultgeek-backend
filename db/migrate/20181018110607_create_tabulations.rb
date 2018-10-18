class CreateTabulations < ActiveRecord::Migration[5.1]
  def change
    create_table :tabulations do |t|
     # t.integer :student_id
      t.belongs_to :student, index: { unique: true }, foreign_key: true
      t.float :gpa
      t.float :tce
      t.string :result
      t.string :remarks
      t.timestamps
    end
  end
end

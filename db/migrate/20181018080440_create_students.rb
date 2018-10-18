class CreateStudents < ActiveRecord::Migration[5.1]
  def change
    create_table :students do |t|
      t.string :name
      t.integer :roll
      t.integer :hall
      t.string :hall_name
      t.float :gpa
      t.integer :status, limit:1, default:0
      t.timestamps
    end
  end
end

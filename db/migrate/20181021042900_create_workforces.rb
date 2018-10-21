class CreateWorkforces < ActiveRecord::Migration[5.1]
  def change
    create_table :workforces do |t|
      t.integer :role
      t.integer :status
      t.string :exam_uuid, null:false
      t.timestamps
    end
  end
end

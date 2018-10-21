class CreateTeachers < ActiveRecord::Migration[5.1]
  def change
    create_table :teachers do |t|
      t.string :title
      t.string :fullname
      t.integer :designation, limit:1, default:0 
      t.belongs_to :dept, index:true, foreign_key: true
      t.string :address
      t.string :email
      t.integer :phone
      t.integer :status, limit:1, default:0
      t.timestamps
    end
  end
end

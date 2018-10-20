class AddUuidToExams < ActiveRecord::Migration[5.1]
  def change
    add_column :exams, :uuid, :string
    add_index :exams, :uuid, unique: true 
  end
end

class RemoveFullnameFromExams < ActiveRecord::Migration[5.1]
  def change
    remove_column :exams, :fullname
  end
end

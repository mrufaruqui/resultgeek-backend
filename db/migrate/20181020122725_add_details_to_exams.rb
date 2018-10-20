class AddDetailsToExams < ActiveRecord::Migration[5.1]
  def change
    remove_column :exams, :held_in
  end
end

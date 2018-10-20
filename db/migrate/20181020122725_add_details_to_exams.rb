class AddDetailsToExams < ActiveRecord::Migration[5.1]
  def change
    add_column :exams, :held_in, :string
  end
end

class AddFullnameToExams < ActiveRecord::Migration[5.1]
  def change
    add_column :exams, :fullname, :string
  end
end

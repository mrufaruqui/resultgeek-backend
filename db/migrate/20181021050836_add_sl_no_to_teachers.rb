class AddSlNoToTeachers < ActiveRecord::Migration[5.1]
  def change
    add_column :teachers, :sl_no, :integer
  end
end

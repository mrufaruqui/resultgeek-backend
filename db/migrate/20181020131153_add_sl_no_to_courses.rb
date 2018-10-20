class AddSlNoToCourses < ActiveRecord::Migration[5.1]
  def change
    add_column :courses, :sl_no, :integer, index:true
  end
end

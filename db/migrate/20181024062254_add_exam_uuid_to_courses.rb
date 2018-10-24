class AddExamUuidToCourses < ActiveRecord::Migration[5.1]
  def change
    add_column :courses, :exam_uuid, :integer, index:true
    add_reference :courses, :exam, index: true 
  end
end

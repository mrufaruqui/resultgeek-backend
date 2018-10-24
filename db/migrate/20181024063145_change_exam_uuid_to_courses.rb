class ChangeExamUuidToCourses < ActiveRecord::Migration[5.1]
  def change
      change_column :courses, :exam_uuid, :string
  end
end

class AddCourseToSummations < ActiveRecord::Migration[5.1]
  def change
     add_reference :summations, :course, index: true
  end
end

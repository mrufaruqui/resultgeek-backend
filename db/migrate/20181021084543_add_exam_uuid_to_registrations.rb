class AddExamUuidToRegistrations < ActiveRecord::Migration[5.1]
  def change
    add_column :registrations, :exam_uuid, :string, index:true
  end
end

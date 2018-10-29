class AddExamUuidToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :exam_uuid, :string, index:true, null:true
  end
end

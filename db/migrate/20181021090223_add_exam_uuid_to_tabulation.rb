class AddExamUuidToTabulation < ActiveRecord::Migration[5.1]
  def change
    add_column :tabulations, :exam_uuid, :string, index:true
  end
end

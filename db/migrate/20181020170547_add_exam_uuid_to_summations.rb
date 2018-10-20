class AddExamUuidToSummations < ActiveRecord::Migration[5.1]
  def change
    add_column :summations, :exam_uuid, :string
  end
end

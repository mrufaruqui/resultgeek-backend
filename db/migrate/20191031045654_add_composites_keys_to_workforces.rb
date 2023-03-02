class AddCompositesKeysToWorkforces < ActiveRecord::Migration[5.1]
  def change
    #add_index :workforces, [:exam_id, :teacher_id, :role], unique: true
  end
end

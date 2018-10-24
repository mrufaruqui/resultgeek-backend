class CreateTennats < ActiveRecord::Migration[5.1]
  def change
    create_table :tennats do |t|
      t.references :exam, foreign_key: true
      t.string :exam_uuid, index: true
    end
  end
end

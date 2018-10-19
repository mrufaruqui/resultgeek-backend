class CreateTabulationDetails < ActiveRecord::Migration[5.1]
  def change
    create_table :tabulation_details do |t|
      t.belongs_to :summation, index: true, foreign_key: true
      t.belongs_to :tabulation, index: true, foreign_key: true
      t.timestamps
    end
  end
end

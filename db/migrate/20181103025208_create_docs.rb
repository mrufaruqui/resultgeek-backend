class CreateDocs < ActiveRecord::Migration[5.1]
  def change
    create_table :docs do |t|
      t.string :exam_uuid
      t.string :uuid
      t.string :latex_name
      t.string :latex_loc
      t.string :pdf_name
      t.string :pdf_loc
      t.string :xls_name
      t.string :xls_loc
      t.string :description

      t.timestamps
    end
  end
end

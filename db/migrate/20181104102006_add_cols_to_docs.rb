class AddColsToDocs < ActiveRecord::Migration[5.1]
  def change
    add_column :docs, :latex_str, :binary
    add_column :docs, :pdf_str, :binary
  end
end

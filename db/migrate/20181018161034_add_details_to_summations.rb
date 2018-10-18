class AddDetailsToSummations < ActiveRecord::Migration[5.1]
  def change
    add_column :summations, :marks, :string
    add_column :summations, :remarks, :string
    add_column :summations, :percetage, :float 
  end
end


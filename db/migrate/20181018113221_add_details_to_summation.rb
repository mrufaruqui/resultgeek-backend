class AddDetailsToSummation < ActiveRecord::Migration[5.1]
  def change
    add_column :summations, :section_a_code, :string
    add_column :summations, :section_b_code, :string
  end
end

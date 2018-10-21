class AddCodeToDepts < ActiveRecord::Migration[5.1]
  def change
    add_column :depts, :code, :string
  end
end

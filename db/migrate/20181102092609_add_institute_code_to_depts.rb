class AddInstituteCodeToDepts < ActiveRecord::Migration[5.1]
  def change
    add_column :depts, :institute_code, :string
  end
end

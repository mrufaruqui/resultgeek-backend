class AddInstituteToDepts < ActiveRecord::Migration[5.1]
  def change
    add_column :depts, :institute, :string
  end
end

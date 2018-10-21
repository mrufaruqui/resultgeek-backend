class ChangeRoleToBeStringInWorkforces < ActiveRecord::Migration[5.1]
  def change
  change_column :workforces, :role, :string, default: :member
  end
end

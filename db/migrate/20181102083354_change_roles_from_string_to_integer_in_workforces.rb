class ChangeRolesFromStringToIntegerInWorkforces < ActiveRecord::Migration[5.1]
  def change
     change_column :workforces, :role, :integer, default:0
  end
end

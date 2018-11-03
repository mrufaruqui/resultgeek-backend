class ChangeRolesFromStringToIntegerInWorkforces < ActiveRecord::Migration[5.1]
  def change
     change_column :workforces, :role, type:integer{2}, limit:1, default:0
  end
end

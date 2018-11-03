class ChangeRolesFromStringToIntegerInWorkforces < ActiveRecord::Migration[5.1]
  def change
     remove_column :workforces, :role
     add_column :workforces, :role, :integer, limit:1, default:0
  end
end

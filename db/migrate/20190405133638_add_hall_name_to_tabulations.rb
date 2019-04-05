class AddHallNameToTabulations < ActiveRecord::Migration[5.1]
  def change
    add_column :tabulations, :hall_name, :string
  end
end

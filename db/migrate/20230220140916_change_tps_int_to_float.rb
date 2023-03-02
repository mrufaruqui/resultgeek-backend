class ChangeTpsIntToFloat < ActiveRecord::Migration[6.1]
  def change
    change_column :tabulations, :tps, :float
  end
end

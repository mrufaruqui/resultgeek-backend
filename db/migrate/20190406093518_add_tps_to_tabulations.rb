class AddTpsToTabulations < ActiveRecord::Migration[5.1]
  def change
    add_column :tabulations, :tps, :integer,  default: 0 
  end
end

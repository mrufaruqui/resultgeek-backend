class AddCactToSummations < ActiveRecord::Migration[5.1]
  def change
    add_column :summations, :cact, :float
  end
end

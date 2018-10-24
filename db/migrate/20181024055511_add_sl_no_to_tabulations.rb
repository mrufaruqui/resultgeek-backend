class AddSlNoToTabulations < ActiveRecord::Migration[5.1]
  def change
    add_column :tabulations, :sl_no, :integer
  end
end

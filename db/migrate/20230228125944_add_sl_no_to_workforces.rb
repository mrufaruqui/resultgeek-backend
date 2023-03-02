class AddSlNoToWorkforces < ActiveRecord::Migration[6.1]
  def change
    add_column :workforces, :sl_no, :integer
  end
end

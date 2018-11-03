class AddSlNoToRegistrations < ActiveRecord::Migration[5.1]
  def change
    add_column :registrations, :sl_no, :integer
  end
end

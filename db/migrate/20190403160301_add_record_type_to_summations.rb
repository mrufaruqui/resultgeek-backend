class AddRecordTypeToSummations < ActiveRecord::Migration[5.1]
  def change
    add_column :summations, :record_type, :integer, limit:1, default: 0 
  end
end

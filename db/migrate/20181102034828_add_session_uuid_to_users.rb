class AddSessionUuidToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :session_uuid, :string
    add_index :users, :session_uuid
  end
end

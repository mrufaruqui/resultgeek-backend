class CreateSessions < ActiveRecord::Migration[5.1]
  def change
    create_table :sessions do |t|
      t.string :uuid, :null => false
      t.string :exam_uuid

      t.timestamps
    end

    add_index :sessions, :uuid, :unique => true
    add_index :sessions, :exam_uuid
    add_index :sessions, :updated_at
  end
end


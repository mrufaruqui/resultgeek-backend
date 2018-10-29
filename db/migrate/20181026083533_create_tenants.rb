class CreateTenants < ActiveRecord::Migration[5.1]
  def change
    create_table :tenants do |t|
      t.references :exam, foreign_key: true
      t.string :exam_uuid, index:true
      t.datetime :login_time
      t.datetime :logout_time
      t.timestamps
    end
  end
end

class AddReferencesToWorkforces < ActiveRecord::Migration[5.1]
  def change
    add_reference :workforces, :exam, index: true 
    add_reference :workforces, :teacher, index: true  
  end
end 
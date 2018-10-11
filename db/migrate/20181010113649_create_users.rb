class CreateUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |t|
      t.string :USERNAME
      t.string :NAME
      t.string :PASSWORD 
      t.string :EMAIL
      t.string :ROLE
      t.string :STATUS           
    end    
  end
end

class CreateRoles < ActiveRecord::Migration[5.2]
  def change
    create_table :roles do |t|
      t.string :ROLE
      t.string :ENDPOINT
      #t.string :VERBS     
    end  
  end
end

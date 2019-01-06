class CreateRoles < ActiveRecord::Migration[5.2]
  def change
    create_table :roles, id: false do |t|
      t.string :role, primary_key: true
      t.string :description
    end  
  end
end

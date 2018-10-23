class CreateRoles < ActiveRecord::Migration[5.2]
  def change
    create_table :roles, id: false do |t|
      t.string :role
      t.string :endpoint
      t.string :verbs  
    end  
  end
end

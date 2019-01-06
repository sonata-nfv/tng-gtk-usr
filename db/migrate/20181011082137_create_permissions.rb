class CreatePermissions < ActiveRecord::Migration[5.2]
  def change
    create_table :permissions, id: false do |t|
      t.string :role
      t.string :endpoint, primary_key: true
      t.string :verbs  
    end  
  end
end

class CreateUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :users, id: false do |t|
      t.string :username, primary_key: true
      t.string :name
      t.string :password
      t.string :email
      t.string :role
      t.string :status           
    end    
  end
end

class ChangePermissions < ActiveRecord::Migration[5.2]
  #def change
  #  remove_column :users, :role, :string
  #  add_column :users, :role, :string, references: :role
  #  change_column :users, :role, :string
  #  add_column :roles, :role, :string
  #  add_index :users, :foo_bar_store_id
  #end
  def up    
    drop_table :users
    create_table :users, id: false do |t|
      t.string :username, primary_key: true, null: false
      t.string :name
      t.string :password
      t.string :email
      t.string :role, null: false
      t.string :status
      t.timestamps     
    end    
    add_index :users, [:username], name: "index_users_on_username", unique: true, using: :btree
    add_foreign_key :users, :roles, column: :role, primary_key: :role

    drop_table :permissions
    create_table :permissions do |t|
      t.string :role, null: false
      t.string :endpoint, null: false
      t.string :verbs, null: false
      t.timestamps
    end
    add_foreign_key :permissions, :roles, column: :role, primary_key: :role
    add_index :permissions, [:endpoint, :role], name: "index_permissions_on_endpoint_role", unique: true
  end
  def down
    drop_table :users
    create_table :users, id: false do |t|
      t.string :username, primary_key: true
      t.string :name
      t.string :password
      t.string :email
      t.string :role
      t.string :status           
    end    
    
    drop_table :permissions
    create_table :permissions, id: false do |t|
      t.string :role
      t.string :endpoint
      t.string :verbs  
    end
    #remove_index :permissions, name: :index_permissions_on_endpoint_role_verbs
  end
end

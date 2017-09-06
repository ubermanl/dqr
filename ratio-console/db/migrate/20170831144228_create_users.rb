class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users, id:false do |t|
      t.string :login, null: false, limit: 255
      t.string :name, null: false, limit: 255
      t.string :mail, null: false, limit: 255
      t.string :crypted_password, null: false, limit: 255 
      t.string :password_salt, null: false, limit: 255
      t.string :persistence_token
      t.timestamps null: false
    end
    
    # cambia la PK de rails por login
    execute 'ALTER TABLE users ADD PRIMARY KEY(login);'
  end
  
  def self.down
    drop_table :users
  end
end

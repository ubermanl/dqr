class AddAuthlogicToUser < ActiveRecord::Migration
  def change
    add_column :users, :crypted_password, :string, null: false
    add_column :users, :password_salt, :string, null: false
    add_column :users, :persistence_token, :string
    add_column :users,:login, :string, null: false
  end
end

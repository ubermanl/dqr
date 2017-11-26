class CreateUserPinnedModules < ActiveRecord::Migration
  def change
    create_table :user_pinned_modules, id: false do |t|
      t.string :login, null: false
      t.references :device_module, index: true, foreign_key: true, null: false
    end
    add_foreign_key :user_pinned_modules, :users, primary_key: :login, column: :login
  end
end

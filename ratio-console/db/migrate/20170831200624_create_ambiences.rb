class CreateAmbiences < ActiveRecord::Migration
  def change
    create_table :ambiences do |t|
      t.string :name, null:false 
      t.boolean :is_deleted, null: false, default: false
      t.timestamps null: false
    end
  end
end

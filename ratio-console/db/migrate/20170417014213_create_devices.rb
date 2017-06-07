class CreateDevices < ActiveRecord::Migration
  def change
    create_table :devices do |t|
      t.string :name
      t.references :device_type, index: true, foreign_key: true, null: false
      t.string :model
      t.timestamps null: false
    end
  end
end

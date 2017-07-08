class CreateDeviceModules < ActiveRecord::Migration
  def change
    create_table :device_modules do |t|
      t.references :device
      t.integer :module_type_id
      t.boolean :deleted, default: false
      t.timestamps null: false
    end
  end
end

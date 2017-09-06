class CreateModuleSensors < ActiveRecord::Migration
  def change
    create_table :module_sensors, id:false do |t|
      t.references :device_module, index: true, foreign_key: true
      t.references :sensor_type, index: true, foreign_key: true
      t.boolean :disabled

      t.timestamps null: false
    end
  end
end

class CreateDeviceSensors < ActiveRecord::Migration
  def change
    create_table :device_sensors do |t|
      t.references :device, null: false, foreign_key: true, null: false
      t.references :sensor_type, foreign_key: true, null: false
      t.timestamps null: false
    end
  end
end

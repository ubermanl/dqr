class CreateDeviceEventSensors < ActiveRecord::Migration
  def change
    create_table :device_event_sensors, id:false do |t|
      t.integer :device_event_id, null: false 
      t.integer :sensor_type_id, null: false
      t.decimal :value, precision:8, scale:4, null: false
    end
  end
end

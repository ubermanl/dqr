class DropDeviceSensors < ActiveRecord::Migration
  def change
    remove_foreign_key :sensor_events, :device_sensors
    remove_foreign_key :program_conditions, :device_sensors
    drop_table :device_sensors
  end
end

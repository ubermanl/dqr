class AddIndexToDeviceEventSensors < ActiveRecord::Migration
  def change
    add_index :device_event_sensors, :device_event_id
    add_index :device_event_sensors, :sensor_type_id
  end
  
end

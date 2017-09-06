class DeviceEventSensor < ActiveRecord::Base
  def self.up
    create_table :device_event_sensors, id:false do |t|
      t.integer :device_event_id, null: false
      t.integer :sensor_type_id, null: false
      t.decimal :value, scale:8, precision:4
    end
  end
  def self.down
    drop_table :device_event_sensors
  end
end

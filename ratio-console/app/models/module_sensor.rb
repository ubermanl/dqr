class ModuleSensor < ActiveRecord::Base
  belongs_to :sensor_type
  
  has_many :device_event_sensor, foreign_key: :module_id, primary_key: :module_id
  
  def events
    DeviceEventView.where(module_id: self.device_module_id, sensor_type_id: self.sensor_type_id)
  end
  
  def last_event
    events.order(ts: :desc).first_or_initialize
  end
end

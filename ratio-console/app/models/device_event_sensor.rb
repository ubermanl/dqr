class DeviceEventSensor < ActiveRecord::Base
  belongs_to :sensor_type
  belongs_to :device_event, inverse_of: :sensor_events
  
  protected
  def readonly?
    true
  end
  
end

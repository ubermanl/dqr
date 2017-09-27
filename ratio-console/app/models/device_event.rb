class DeviceEvent < ActiveRecord::Base
  has_many :sensor_events, class_name:'DeviceEventSensor'
  belongs_to :device, inverse_of: :events
  
  protected
  def readonly?
    true
  end
  

end

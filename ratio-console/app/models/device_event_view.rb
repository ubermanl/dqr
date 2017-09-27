class DeviceEventView < ActiveRecord::Base
  
  self.table_name = 'device_events_view'
  
    
  belongs_to :device
  belongs_to :module, class_name:'DeviceModule'
  
  protected
  def readonly?
    true
  end
end
class DeviceDefinitionView < ActiveRecord::Base
  
  self.table_name = 'device_definition_view'
  
  protected
  def readonly?
    true
  end
  
end
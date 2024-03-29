class ModuleSensorsController < ApplicationController
  before_action :set_module
  def get_events
    @events = @module.events.order(ts: :desc).take(50)
    @sensor_type = @module.sensor_type
    @labels = @module.sensor_type.graphic_scale
    @isBinary = @module.is_binary?
  end
  
  private 
  def set_module
    @module = ModuleSensor.find_by_device_module_id_and_sensor_type_id(params[:device_module_id],params[:sensor_type_id])
  rescue ActiveRecord::RecordNotFound
    flash[:error] = "Module Not Found"
    redirect_to devices_url
  end
end

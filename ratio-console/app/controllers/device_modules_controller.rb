class DeviceModulesController < ApplicationController
  before_action :set_module, only: [:activate,:deactivate]
  
  def deactivate
    @result = @module.fsm_deactivate
    respond_to do |format|
      format.json
      format.html { redirect_to device_url(@module.device_id)}
    end
  end
  
  def activate 
    @result = @module.fsm_activate
    respond_to do |format|
      format.json
      format.html { redirect_to device_url(@module.device_id)}
    end
  end
  
  private 
  def set_module
    @module = DeviceModule.find(params[:device_module_id])
  end
end

class DeviceModulesController < ApplicationController
  before_action :set_module, only: [:activate,:deactivate]
  
  def deactivate
    @module.deactivate
    respond_to do |format|
      format.js {}
      format.html { redirect_to device_url(@module.device_id)}
    end
  end
  
  def activate 
    @module.deactivate
    respond_to do |format|
      format.js {}
      format.html { redirect_to device_url(@module.device_id)}
    end
  end
  
  private 
  def set_module
    @module = DeviceModule.find(params[:device_module_id])
  end
end

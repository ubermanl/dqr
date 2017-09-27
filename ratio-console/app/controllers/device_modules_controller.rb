class DeviceModulesController < ApplicationController
  before_action :set_module, only: [:activate,:deactivate]
  
  def deactivate
    if params[:override].present? && params[:override] == 1
      @module.deactivate_override
    else
      @module.deactivate
    end
    respond_to do |format|
      format.js {}
      format.html { redirect_to device_url(@module.device_id)}
    end
  end
  
  def activate 
    if params[:override].present? && params[:override] == 1
      @module.activate_override
    else
      @module.activate
    end
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

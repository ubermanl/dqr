class DeviceModulesController < ApplicationController
  before_action :set_module, only: [:activate,:deactivate,:set_status]
  
  def deactivate
    @result = @module.deactivate_override
    respond_to do |format|
      format.json { render json: @result, status: :ok }
      format.html { redirect_to device_url(@module.device_id)}
    end
  end
  
  def activate 
    @result = @module.activate_override
    respond_to do |format|
      format.json { render json: @result, status: :ok }
      format.html { redirect_to device_url(@module.device_id)}
    end
  end
  
  def set_status
    respond_to do |format|
      if ['0','1'].include?(@status)
        @result = @status == '1' ? @module.activate_override : @module.deactivate_override
        format.json { render json: @result, status: :ok }
        format.html { redirect_to device_url(@module.device_id)}
      else
        @result = { exit_code: exit_status, output: result }
        flash[:error] = 'Invalid status'
        format.json { render status: :unprocesable_entity }
        format.html { redirect_to device_url(@module.device_id)}
      end
    end
  end
  
  private 
  def set_module
    @module = DeviceModule.find(params[:device_module_id])
    @status = params[:status]
  rescue ActiveRecord::RecordNotFound
    flash[:error] = "Device Not Found"
    redirect_to devices_url
  end
end

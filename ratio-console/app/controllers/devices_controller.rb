class DevicesController < ApplicationController
  before_action :set_device, only: [:show]
  
  def index
    @devices = Device.includes(:ambience,modules:[:module_type]).all
  end
  
  def new 
    @device = Device.new
  end
  
  def show
    
  end
  
  def create
    @device = Device.create(device_params)
    respond_to do |format|
      if @device.save 
        format.html { redirect_to @device, notice: 'Device was successfully created.' }
      else
        format.html { render :new } 
      end
    end
  end
  
  
  private
  def set_device
    @device = Device.find(params[:id])
  end
  
  def device_params
    params.require(:device).permit(:id,:name,:ambience_id)
  end
end

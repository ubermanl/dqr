class DevicesController < ApplicationController
  before_action :set_device, only: [:show,:edit,:update]
  
  def index
    @devices = Device.includes(:ambience,modules:[:module_type]).all
  end
  
  def new 
    @device = Device.new
  end
  
  def edit
    
  end
  
  def detect
    
  end
  
  def show
    if @device.detection_pending?
      redirect_to detect_device_url(@device)
    end
  end
  
  def update
    respond_to do |format|
      if @device.update(device_params) 
        format.html { redirect_to @device, notice: 'Device was successfully created.' }
      else
        format.html { render :new } 
      end
    end
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
    @preferences = ConsolePreference.first
  end
  
  def device_params
    params.require(:device).permit(:id,:name,:ambience_id,modules_attributes: [:id, :name, :show_in_dashboard ])
  end
end

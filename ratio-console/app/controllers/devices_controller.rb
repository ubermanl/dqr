class DevicesController < ApplicationController
  before_action :set_device, only: [:show,:edit,:update, :detect, :has_data]
  
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
  
  def has_data
    respond_to do |format|
      if @device.events.any?
        format.json { render json: { :detection_staus => 'ok', :goto => edit_device_url(@device) }, status: :ok }
      else
        format.json { render json: { :detection_staus => 'pending' }, status: :ok }
      end
    end
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
        format.html { render :edit } 
      end
    end
  end
  
  def create
    @device = Device.create(device_params)
    respond_to do |format|
      if @device.save 
        format.html { redirect_to detect_device_url(@device), notice: 'Device was successfully created.' }
      else
        format.html { render :new } 
      end
    end
  end
  
  
  private
  def set_device
    @device = Device.find(params[:id])
    @preferences = ConsolePreference.first
  rescue ActiveRecord::RecordNotFound
    flash[:error] = "Device Not Found"
    redirect_to action: :index
  end
  
  def device_params
    params.require(:device).permit(:id,:name,:ambience_id,modules_attributes: [:id, :name, :module_type_id, :show_in_dashboard ])
  end
end

class ScheduleModulesController < ApplicationController
  before_action :set_schedule, only:[:update,:destroy]
  
  def create
    @schedule_module = ScheduleModule.new(schedule_module_params)
    @schedule_module.schedule_id = params[:schedule_id]
    respond_to do |format|
      if @schedule_module.save 
        format.json { render json:{ status: 'OK', schedule_module_id: @schedule_module.id }, status: :ok }
        format.html { redirect_to @schedule_module.schedule }
      else
        format.json { render json: @schedule_module.errors, status: :unprocessable_entity }
        format.html { redirect_to @schedule_module.schedule, notice: 'Error' }
      end
    end
  end
  
  
  def destroy
    respond_to do |format|
      if @schedule_module.destroy 
        format.json { render json:{ status: 'OK' }, status: :ok }
        format.html { redirect_to @schedule_module.schedule }
      else
        format.json { render json:{ status: 'Error', errors: @schedule_module.errors }, status: :unprocessable_entity }
        format.html { redirect_to @schedule_module.schedule, notice: 'Error' }
      end
    end
  end
  
  def update
    respond_to do |format|
      @schedule_module.desired_status = schedule_module_params[:desired_status]
      if @schedule_module.save
        format.json { render json:{ status: 'OK', schedule_module_id: @schedule_module.id, new_status: @schedule_module.desired_status }, status: :ok }
        format.html { redirect_to @schedule_module.schedule }
      else
        format.json { render json:{ status: 'Error', errors: @schedule_module.errors }, status: :unprocessable_entity }
        format.html { redirect_to @schedule_module.schedule, notice: 'Error' }
      end
    end
  end
  
  private
  def set_schedule
    @schedule = Schedule.find(params[:schedule_id])
    @schedule_module = ScheduleModule.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    flash[:error] = 'Schedule not found'
    redirect_to schedules_url
  end
  
  def schedule_module_params
    params.require(:schedule_module).permit(:desired_status,:device_module_id,:include)
  end
  
end

class ScheduleModulesController < ApplicationController
  before_action :set_schedule, only:[:create]
  
  def create
    if schedule_module_params[:include] == 0 && schedule_module_params[:device_module_id].present?
      @schedule.schedule_modules.where(:device_module_id => schedule_module_params[:device_module_id]).delete
    else
      @schedule_module = @schedule.schedule_modules.where(device_module_id: schedule_module_params[:device_module_id])
      if @schedule_module.any?
        @schedule_module.update(schedule_module_params)
      else
        @schedule_module = ScheduleModule.create(schedule_module_params)
        @schedule_module.save
      end
    end
    respond_to do |format|
      if @schedule_module.errors.none?
        format.json { render json: { status: 'ok' }, status: :ok }
        format.html { redirect_to @schedule, notice: 'Successfully Included' }
      else
        format.json { render json: { status: @schedule_module.errors }, status: :unprocessable_entity }
        format.html { redirect_to @schedule }
      end  
    end
  end
  
  
  private 
  def set_schedule
    @schedule = Schedule.find(schedule_module_params[:schedule_id])
  end
  def schedule_module_params
    params.require(:schedule_module).permit(:schedule_id, :device_module_id, :desired_state,:include)
  end
end
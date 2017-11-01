class ScheduleDaysController < ApplicationController
  before_action :set_schedule

  def create
    @schedule_day = ScheduleDay.new :schedule_id => schedule_params[:schedule_id],
                                    :day => schedule_params[:day],
                                    :start_hour => p_start_hour,
                                    :end_hour => p_end_hour
                                    
    Rails.logger.warn schedule_params
    respond_to do |format|
      if @schedule_day.save
        format.json { }
        format.html { redirect_to @schedule, notice: 'Schedule Created successfully' }
      else
        format.json { render json: @schedule_day.errors, status: :unprocessable_entity }
        format.html { redirect_to @schedule, notice: 'Something went wrong'}
      end
    end
  end
  
  private 
  def set_schedule
    @schedule = Schedule.find(schedule_params[:schedule_id])
  end
  
  def schedule_params
    params.require(:schedule_day).permit(:schedule_id,:start_hour,:end_hour,:day)
  end

  # fechas de parmetros
  def p_start_hour
    schedule_params['start_hour(4i)'] + ':' + schedule_params['start_hour(5i)']
  end
  
  def p_end_hour
    schedule_params['end_hour(4i)'] + ':' + schedule_params['end_hour(5i)']
  end

end

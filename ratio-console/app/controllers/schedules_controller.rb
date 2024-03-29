class SchedulesController < ApplicationController
  before_action :require_admin, only: [:edit, :update, :destroy,:create]
  before_action :set_schedule, only: [:show, :edit, :update, :destroy, :schedules]

  # GET /schedules
  # GET /schedules.json
  def index
    @schedules = Schedule.all
  end
  
  def schedules
    
  end

  # GET /schedules/1
  # GET /schedules/1.json
  def show
    @available_modules = DeviceModule.includes(:module_type).all.order(:name)
    @included_modules = @schedule.schedule_modules.collect{ |t| [t.device_module_id,t.id,t.desired_status] }
  end

  # GET /schedules/new
  def new
    @schedule = Schedule.new
  end

  # GET /schedules/1/edit
  def edit
  end

  # POST /schedules
  # POST /schedules.json
  def create
    @schedule = Schedule.new(schedule_params)

    respond_to do |format|
      if @schedule.save
        format.html { redirect_to @schedule, notice: 'Schedule was successfully created.' }
        format.json { render :show, status: :created, location: @schedule }
      else
        format.html { render :new }
        format.json { render json: @schedule.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /schedules/1
  # PATCH/PUT /schedules/1.json
  def update
    respond_to do |format|
      if @schedule.update(schedule_params)
        format.html { redirect_to @schedule, notice: 'Schedule was successfully updated.' }
        format.json { render :show, status: :ok, location: @schedule }
      else
        format.html { render :edit }
        format.json { render json: @schedule.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /schedules/1
  # DELETE /schedules/1.json
  def destroy
    @schedule.destroy
    respond_to do |format|
      format.html { redirect_to schedules_url, notice: 'Schedule was successfully destroyed.' }
      format.json { render json: { status: 'ok' }, status: :ok }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_schedule
      @schedule = Schedule.includes([:schedule_modules,:schedule_days]).find(params[:id])
    rescue ActiveRecord::RecordNotFound
      flash[:error] = "Schedule Not Found"
      redirect_to action: :index
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def schedule_params
      params.require(:schedule).permit(:description, :inactive, :enabled)
    end
end

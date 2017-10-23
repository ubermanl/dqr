class ConsolePreferencesController < ApplicationController
  before_action :set_console_preference, only: [:edit, :update]


  # GET /console_preferences/1/edit
  def edit
  end



  # PATCH/PUT /console_preferences/1
  # PATCH/PUT /console_preferences/1.json
  def update
    respond_to do |format|
      if ConsolePreference.update_all(console_preference_params)
        format.html { redirect_to console_preferences_url, notice: 'Console preferences successfully updated.' }
        format.json { render :show, status: :ok, location: @console_preferences }
      else
        format.html { render :edit }
        format.json { render json: @console_preferences.errors, status: :unprocessable_entity }
      end
    end
  end


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_console_preference
      @console_preferences = ConsolePreference.first
      if @console_preferences.nil?
        @console_preferences = ConsolePreference.new
      end
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def console_preference_params
      params.require(:console_preference).permit(:graphic_refresh_interval, :graphic_interval)
    end
end

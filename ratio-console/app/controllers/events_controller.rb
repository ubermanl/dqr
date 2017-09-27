class EventsController < ApplicationController
  before_action :set_last_id
  
  
  def index
    if @last_event_id > 0
      @events = DeviceEvent.where('id < ?',@last_event_id).order(id: :desc).take(10)
    else
      @events = DeviceEvent.order(id: :desc).take(10)
    end
  end
  
  private
  def set_last_id
    if params[:last_event_id].present?
      @last_event_id = params[:last_event_id].to_i
    else
      @last_event_id = 0
    end
  end
end

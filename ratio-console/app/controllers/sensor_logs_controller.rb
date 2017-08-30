class SensorLogsController < ApplicationController
  def index
    @logs = SensorLog.all
  end
end

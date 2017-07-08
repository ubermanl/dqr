class SensorLogDatum < ActiveRecord::Base
  belongs_to :sensor_log
  belongs_to :sensor
end

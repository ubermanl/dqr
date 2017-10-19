class ScheduleModule < ActiveRecord::Base
  belongs_to :device_module
  belongs_to :schedule
end

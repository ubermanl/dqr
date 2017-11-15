class ScheduleModule < ActiveRecord::Base
  belongs_to :device_module
  belongs_to :schedule, inverse_of: :schedule_modules
  
end

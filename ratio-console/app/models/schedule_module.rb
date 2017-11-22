class ScheduleModule < ActiveRecord::Base
  belongs_to :device_module
  belongs_to :schedule, inverse_of: :schedule_modules
  
  validate :validate_others
  
  def validate_others
    other_schedules = ScheduleModule.where('device_module_id = ? and not schedule_id = ?',self.device_module_id, self.schedule_id)
    if other_schedules.any?
      errors.add(:base, 'This module cannot be included, it\'s already included in another schedule')
    end
  end
end

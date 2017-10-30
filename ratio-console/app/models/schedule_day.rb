class ScheduleDay < ActiveRecord::Base
  belongs_to :schedule
  
  validates :start_hour, presence: true
  validates :end_hour, presence: true
  validate :cronology
  validate :everyday_day
  
  
  def cronology
    if start_hour > end_hour
      errors.add(:start_hour, 'A schedule can\'t begin after it starts')
    end
  end
  
  def everyday_day
    if self.schedule.schedule_days.where(:day => 0).any?
      errors.add(:day, 'An Everyday schedule is defined, can\'t add another definition')
    end
  end
  
  
end

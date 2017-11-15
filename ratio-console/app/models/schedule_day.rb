class ScheduleDay < ActiveRecord::Base
  belongs_to :schedule
  
  validates :start_hour, presence: true
  validates :end_hour, presence: true
  validate :cronology
  validate :everyday_day
  validate :overlap
  
  
  def cronology
    if start_hour.present? && end_hour.present?
      if start_hour > end_hour
        errors.add(:start_hour, 'A schedule can\'t begin after it starts')
      end
      if start_hour == end_hour
        errors.add(:start_hour, 'A schedule can\'t have same start and end hour')
      end
    end
  end
  
  def everyday_day
    if self.schedule.schedule_days.where(:day => 0).any? && self.day != 0
      errors.add(:day, 'An Everyday schedule is defined, can\'t add this definition')
    end
    if self.schedule.schedule_days.where.not(:day => 0).any? && self.day == 0
      errors.add(:day, 'Can\'t define an Everyday Schedule if normal schedules are present')
    end
  end
  
  def overlap
    if start_hour.present? && end_hour.present?
      start_overlap = self.schedule.schedule_days.where('start_hour <= ? and end_hour >= ? and day = ?', self.start_hour, self.start_hour, self.day).any?
      end_overlap = self.schedule.schedule_days.where('start_hour <= ? and end_hour >= ? and day = ?', self.end_hour, self.end_hour,self.day).any?
      if start_overlap || end_overlap
        errors.add(:day,'Another schedule overlaps with this definition')
      end
    end
  end
  
  # scope returning all schedule_days containing the time gap desired for the day or everyday
  scope :containing, ->(day,time){ where('(day = ? or day = 0) and start_hour <= ? and end_hour >= ?',day,time,time)}
  
  
end

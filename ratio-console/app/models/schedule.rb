class Schedule < ActiveRecord::Base
  has_many :schedule_days, dependent: :destroy
  has_many :schedule_modules, dependent: :destroy
  
  validates :description, presence: true
  
  scope :active, ->{ where(enabled: true) }
  
  def should_apply?
    # for ruby a value between 0 and 6 with 0 sunday
    week_day = Time.now.wday
    now = Time.now.strftime('%H:%M')
    Rails.logger.info now
    # for Ratio 0 - Everyday and 7 - Sunday, then remap
    schedule_week_day = case week_day
                        when 0 then 7 # sunday
                        else week_day 
                      end
    schedule_days.containing(schedule_week_day,now).any?
  end
  
end

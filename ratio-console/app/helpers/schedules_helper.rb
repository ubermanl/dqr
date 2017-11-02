module SchedulesHelper
  def week_day(day)
    day_names = [
      'All',
      'Mon',
      'Tue',
      'Wed',
      'Thu',
      'Fri',
      'Sat',
      'Sun'
    ]
    day_names[day]
  end
  def schedule_tooltip(schedule)
     day_names = [
      'Every Day',
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday'
    ]
    day_names[schedule.day] + ' from ' + schedule.start_hour + ' to ' + schedule.end_hour
  end
  
  def prepare_days(schedule)
    absent_days = (0..7).to_a - schedule.schedule_days.collect{ |t| t.day }.uniq
    absent_days.each do |a|
      schedule.schedule_days.new day: a, start_hour:'00:00', end_hour:'00:00'
    end
    schedule
  end
end

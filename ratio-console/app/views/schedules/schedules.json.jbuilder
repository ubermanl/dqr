json.schedule_days @schedule.schedule_days do |s|
  json.day s.day
  json.start_hour s.start_hour
  json.end_hour s.end_hour
end
json.everyday @schedule.schedule_days.where(:day => 0).any?
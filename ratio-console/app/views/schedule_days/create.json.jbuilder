json.html render partial:'list.html.erb'
json.everyday @schedule.schedule_days.where(:day => 0).any?
json.lastId @schedule_day.id
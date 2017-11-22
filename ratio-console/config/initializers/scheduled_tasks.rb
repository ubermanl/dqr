require 'rufus/scheduler'

scheduler = Rufus::Scheduler.new

# if app restarts all schedules are turned to false
Schedule.update_all(is_running: false)

scheduler.every '1m' do
  # iterate over defined schedules
  Rails.logger.debug "RatioScheduler: Checking Schedules"
  active_schedules = Schedule.includes(:schedule_modules => [:device_module]).active.all
  active_schedules.each do |schedule|
    # if in time for action
    if schedule.should_apply?
      Rails.logger.debug "RatioScheduler: Found one schedule to apply"    
      if !schedule.is_running?
        Rails.logger.debug "RatioScheduler: Spinning up the schedule"    
        # toggle al involved modules
        schedule.schedule_modules.each do |m|
          if m.device_module.last_known_status != m.desired_status
            # save previous state
            m.device_module.save_status_and_mark
            # do transition to desired
            m.device_module.transition_to(m.desired_status)
            Rails.logger.debug "RatioScheduler: #{m.device_module.name} transitioned to state #{m.desired_status}"
          end
        end
        # mark running
        schedule.is_running = true
        schedule.save
        Rails.logger.debug "RatioScheduler: Activated!"    
      end
    else
      # if module no longer applies but it was running, then
      # revert all states
      if schedule.is_running?
        Rails.logger.debug "RatioScheduler: Found one schedule to stop"    
        schedule.schedule_modules.each do |m|
          if m.device_module.last_known_status != m.previous_state
            # do transition to desired
            m.device_module.transition_to(m.device_module.previous_state)
            Rails.logger.debug "RatioScheduler: #{m.device_module.name} reverted to state #{m.device_module.previous_state}"
          end
        end
        schedule.is_running = false
        schedule.save
        Rails.logger.debug "RatioScheduler: Scheduled Stopped"    
      end
    end
  end
  Rails.logger.warn 'RatioScheduler: Done Checking'
end
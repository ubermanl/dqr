class ScheduleDaysController < ApplicationController
  def day_names_helper
    day_names = {
      '0' => 'Every Day',
      '1' => 'Monday',
      '2' => 'Tuesday',
      '3' => 'Wednesday',
      '4' => 'Thursday',
      '5' => 'Friday',
      '6' => 'Saturday',
      '7' => 'Sunday'
    }
    options_for_select day_names, :first,:last
  end
end

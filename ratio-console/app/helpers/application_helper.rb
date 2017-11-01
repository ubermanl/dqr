module ApplicationHelper
  def text_with_icon(text,icon)
    semantic_icon(icon) + text
  end
  
  def human_bool(value)
    value ? 'Yes' : 'No'
  end
  
  def day_names_helper
    day_names = {
      '1' => 'Monday',
      '2' => 'Tuesday',
      '3' => 'Wednesday',
      '4' => 'Thursday',
      '5' => 'Friday',
      '6' => 'Saturday',
      '7' => 'Sunday',
      '0' => 'Every Day'
    }
    options_from_collection_for_select day_names, :first,:last
  end
end

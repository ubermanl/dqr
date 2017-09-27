module ApplicationHelper
  def text_with_icon(text,icon)
    semantic_icon(icon) + text
  end
  
  def human_bool(value)
    value ? 'Yes' : 'No'
  end
end

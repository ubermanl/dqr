module EventsHelper
  def mask_value_na(value)
    value? ? value : 'N/A'
  end
end

module DevicesHelper
  def device_module_name(m)
    m.name.blank? ? m.module_type.name : m.name
  end
end

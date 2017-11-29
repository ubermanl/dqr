class UpdateSensorTypeNewColumns < ActiveRecord::Migration
  def change
    sensor = SensorType.find(1)
    sensor.graph_scale_type = 'Fixed'
    sensor.graph_step = '8'
    sensor.graph_max_value = '8'
    sensor.graph_min_value = '0'
    sensor.graph_description = 'Module current sensing represented in Amperes (A) by the connected device to the power socket. Maximum sensing capabilities registered for 20A.'
    sensor.save
    
    sensor = SensorType.find(2)
    sensor.graph_scale_type = 'Fixed'
    sensor.graph_step = '8'
    sensor.graph_max_value = '2000'
    sensor.graph_min_value = '0'
    sensor.graph_description = 'Luminous emittance displayed in the derived SI unit <i>lux</i>, measuring luminous flux per unit area. Its variance strongly depends in the location of the sensor but can be expected up to 1000 lux for well illuminated indoor locations.'
    sensor.save

    sensor = SensorType.find(3)
    sensor.graph_scale_type = 'Binary'
    sensor.graph_step = '1'
    sensor.graph_max_value = '1'
    sensor.graph_min_value = '0'
    sensor.graph_scale_labels = 'No,Yes'
    sensor.graph_description = 'The passive infrared sensor measures infrared light radiating from objects in its field of view, activating the motion sensor module whenever a moving heat signal is detected. The activation window of 5 minutes gives a smooth behavior to the switching events.'
    sensor.save
    
    sensor = SensorType.find(4)
    sensor.graph_scale_type = 'Fixed'
    sensor.graph_step = '10'
    sensor.graph_max_value = '0'
    sensor.graph_min_value = '100'
    sensor.graph_description = 'Sound pressure level (SPL) is a logarithmic measure of the effective pressure of a sound relative to a reference value, which is set to the commonly used minimum hearing level of p0 = 20 uPa, meaning 1 Pa will equal an SPL of 94 dB. Long-term exposure at sound levels of 85dB or higher can produce hearing damage.'
    sensor.save
    
    sensor = SensorType.find(5)
    sensor.graph_scale_type = 'Fixed'
    sensor.graph_step = '10'
    sensor.graph_max_value = '-20'
    sensor.graph_min_value = '50'
    sensor.graph_description = 'Thermal sensor calibrated in Celsius scale (°C) with a measure range of 0-50°C +/- 2°C.'
    sensor.save
  end
end

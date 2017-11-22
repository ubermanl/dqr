class AddScaleDataToSensorTypes < ActiveRecord::Migration
  def change
    SensorType.all.each do |s|
      value = case s.id
        # current
        when 1 then '0;8:8'
        # lum
        when 2 then '0;1024:4'
        # movement
        when 3 then '0;1:1'
        # sound
        when 4 then '0;100:10'
        # temperature
        when 5 then '-20;50:10'
      end
      s.update_column(:graphic_scale,value)
    end
  end
end

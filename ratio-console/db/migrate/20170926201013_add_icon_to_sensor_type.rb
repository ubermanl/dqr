class AddIconToSensorType < ActiveRecord::Migration
  def self.up
    add_column :sensor_types, :icon, :string, after: :name
    
    # pega todos los updates en los modelos
    icons = {
      1 => { icon: 'lightning'},
      2 => { icon: 'sun'},
      3 => { icon: 'unhide'},
      4 => { icon: 'unmute'},
      5 => { icon: 'half termometer'}
    }
    icons.each do |k,v|
      SensorType.find_by_id(k).try(:update_attribute,:icon,v[:icon])
    end
  end
  
  def self.down
    remove_column :sensor_types, :icon
  end
end

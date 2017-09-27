class AddUnitToSensorTypes < ActiveRecord::Migration
  def self.up
    add_column :sensor_types, :unit, :string, after: :name
    
    # pega todos los updates en los modelos
    updates = {
      1 => { unit: 'mAmp'},
      2 => { unit: 'lum'},
      3 => { unit: ''},
      4 => { unit: 'dB'},
      5 => { unit: 'C'}
    }
    
    updates.each do |k,v|
      s = SensorType.where(id: k)
      if s.any?
        s.update(:unit,v.unit)
      end
    end
  end
  
  def self.down
    remove_column :sensor_types, :unit, :string
  end
end

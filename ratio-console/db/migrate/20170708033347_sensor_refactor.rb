class SensorRefactor < ActiveRecord::Migration
  def change

    remove_column :sensors, :device_id
    add_reference  :sensors,:device_module, foreign_key: true, after: :sensor_type_id
  end
end
